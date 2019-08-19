#---------------------------------------------------------------------------------------------------
# Purpose of this script is to make a nice timeline figure to bring together
# the clinical and genetic findings
#---------------------------------------------------------------------------------------------------
# imports
library(tidyverse)
library(lubridate)
library(ggrepel)
library(vcfR)
library(vcfRmanip)
# data imports
drugreg <- readxl::read_excel("data/clinical_case.xlsx", sheet = 1) %>%
  dplyr::rename(drug_start_date = startdate,
                drug_end_date = enddate) %>%
  dplyr::mutate(drug_start_date = lubridate::ymd(drug_start_date),
                drug_end_date = lubridate::ymd(drug_end_date))
clincourse <- readxl::read_excel("data/clinical_case.xlsx", sheet = 2) %>%
  dplyr::rename(clin_start_date = datestart,
                clin_end_date = dateend) %>%
  dplyr::mutate(clin_start_date = lubridate::ymd(clin_start_date),
                clin_end_date = lubridate::ymd(clin_end_date)) %>%
  dplyr::filter( clin_start_date >= ymd("2017-06-05"))

annvar <- readRDS("data/Sepi_QC_annotated-variants.RDS")
qcvcf <- readRDS("data/Sepi_QC_variantfile.RDS")
varmeta <- readr::read_tsv("~/Documents/GitHub/Sepidermidis_resistance_hosp/metadata.tab.txt") %>%
  dplyr::mutate(smplid = paste0("Sepi", Number),
                wgsCollectionDate = lubridate::mdy(CollectionDate)) %>%
  dplyr::select(c("smplid", "wgsCollectionDate"))

#...................................
# Merge the Clin, Drug, and Genetic Data
#...................................
# soft join on dates
# https://community.rstudio.com/t/tidy-way-to-range-join-tables-on-an-interval-of-dates/7881/2

drugreg.clincourse <- fuzzyjoin::fuzzy_full_join(
  drugreg, clincourse,
  by = c(
    "drug_start_date" = "clin_start_date",
    "drug_end_date" = "clin_end_date"
  ),
  match_fun = list(`<=`, `>=`))




alldat <- fuzzyjoin::fuzzy_full_join(
  drugreg.clincourse, varmeta,
  by = c(
    "drug_start_date" = "wgsCollectionDate",
    "drug_end_date" = "wgsCollectionDate"
  ),
  match_fun = list(`<`, `>=`))


# find max and mins and just set that as the xlim
datmax <- max( unlist(alldat$drug_end_date, alldat$clin_end_date, alldat$wgsCollectionDate), na.rm = T )
datmin <- min( unlist(alldat$drug_start_date, alldat$clin_start_date, alldat$wgsCollectionDate), na.rm = T )

# clin course plot
clindat <- alldat %>%
  dplyr::select(c("clin_start_date", "clin_end_date", "event")) %>%
  dplyr::filter(!duplicated(.)) %>%
  dplyr::filter(!is.na(clin_start_date)) %>%
  dplyr::mutate(clin_start_date_adj = as.Date(clin_start_date),
                clin_end_date_adj = as.Date(clin_end_date),
                intervaltim = lubridate::interval(clin_start_date, clin_end_date),
                intervaltim = intervaltim %/% days(1),
                intervaltim = intervaltim/2,
                xplace = clin_start_date_adj + days(floor(intervaltim)),
                xplace = as.Date(xplace))

drugdat <- alldat %>%
  dplyr::select(c("drug_start_date", "drug_end_date", "drug")) %>%
  dplyr::filter(!duplicated(.)) %>%
  dplyr::filter(!is.na(drug_start_date)) %>%
  dplyr::arrange(drug_start_date) %>%
  dplyr::mutate(drug_start_date_adj = as.Date(drug_start_date),
                drug_end_date_adj = as.Date(drug_end_date),
                intervaltim = lubridate::interval(drug_start_date, drug_end_date),
                intervaltim = intervaltim %/% days(1),
                intervaltim = intervaltim/2,
                xplace = drug_start_date_adj + days(floor(intervaltim)),
                xplace = as.Date(xplace),
                yax = ifelse(stringr::str_detect(drug, "Vancomycin/Ceftaroline"), 0.3,
                             ifelse(stringr::str_detect(drug, "Daptomycin"), 0.1, 0.25))
                )

#.......................................................................
# Make Clinical Plot
#.......................................................................
#...................................
# Pick Some Colors
#...................................
# cyclines in blue
# mycin in purple
# cephalosporings in yellow

drugcol <- c("#67a9cf", "#4d004b", "#ce1256",
             "#6a51a3", "#4292c6", "#fd8d3c",
             "#2261bf", "#9e9ac8", "#b67dba")


clincol <-  c("#a50f15", "#006d2c", "#67000d", "#00441b")

clinplot <- ggplot() +
#  geom_rect(aes(xmin = -Inf, xmax = Inf, ymin=-Inf, ymax=Inf), color = "", fill = "") +
  # drug regimen
  geom_rect(data = drugdat,
            aes(xmin = drug_start_date_adj,
                xmax = drug_end_date_adj,
                ymin = 0, ymax = 0.46,
                fill = drug), alpha = 0.4
  ) +
  # clin data
  geom_jitter(data = clindat,
             aes(x = xplace, y = 0.43,
                 color = factor(event)),
             position = position_jitter(w = 0, h = 0.025),
             size = 5,
             fill = "black"
            ) +
  # drug reg text
  geom_text(data=drugdat,
            aes(x = xplace,
                y = yax,
                label = drug,
                fontface = "bold"), angle = 90
  ) +
  # set scales
  scale_x_date(limits = as.Date(c(datmin, datmax))) +
  scale_fill_manual(values = drugcol, guide = F) + # for drug reg
  scale_color_manual("Clinical Course", values = clincol) +
  xlab("Date (Month)") +

  # all theme
  theme(axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.line.y = element_blank(),
        axis.title.x = element_text(family = "Helvetica", face = "bold", hjust = 0.5, size = 12),
        axis.text.x = element_text(family = "Helvetica", hjust = 0.5, size = 11),
        axis.line.x = element_line(color = "black", size = 1.1),
        legend.position = "top",
        legend.title = element_text(family = "Helvetica", face = "bold", vjust = 0.85, size = 12),
        legend.text = element_text(family = "Helvetica", vjust = 0.5, size = 10),
        panel.background = element_rect(fill = "transparent"),
        plot.background = element_rect(fill = "transparent"),
        panel.grid = element_blank(),
        panel.border = element_blank()) +
  guides(color=guide_legend(nrow=2,byrow=TRUE))


#.......................................................................
# Make Genetic Plot
#.......................................................................
ad <- extract.gt(qcvcf, element = 'AD')
adref <- masplit(ad, record = 1, sort = 0)
adalt <- masplit(ad, record = 2, sort = 0)
gtwsafalt <- adalt / (adref + adalt)

gt.dat <- tibble::tibble(smplid = colnames(gtwsafalt), gt = as.vector(gtwsafalt))
gendat <- alldat %>%
  dplyr::select(c("smplid", "wgsCollectionDate")) %>%
  dplyr::filter(!duplicated(.)) %>%
  dplyr::filter(!is.na(wgsCollectionDate)) %>%
  dplyr::arrange(wgsCollectionDate) %>%
  dplyr::mutate(smplid = tolower(smplid),
                wgsCollectionDate_adj = as.Date(wgsCollectionDate)) %>%
  dplyr::left_join(., gt.dat, by = "smplid")

# remind me for paste
annvar.text


genomicplot <- ggplot() +
  geom_line(data = gendat, aes(x = wgsCollectionDate_adj, y = gt), size = 2, alpha = 0.2) +
  geom_point(data = gendat, aes(x = wgsCollectionDate_adj, y = gt), size = 3) +
  geom_text(data = annvar.text, aes(x=as.Date("2017-08-31"), y=0.5,
                                    label = paste("POS: 26858 \n REF: C \n ALT: T \n AA: P415L")),
            fontface = "bold", size = 3) +
  # set scales
  scale_x_date(limits = as.Date(c(datmin, datmax))) +
  xlab("Date (Month)") +
  ylab("Allele Frequency") + ylim(-0.05, 1.05) +
  scale_y_continuous(breaks = c(0, 1)) +

  # all theme
  theme_minimal() +
  theme(axis.title = element_text(family = "Helvetica", face = "bold", hjust = 0.5, size = 12),
        axis.text = element_text(family = "Helvetica", hjust = 0.5, size = 11),
        axis.line = element_line(color = "black", size = 1.1),
        legend.position = "none")

#.......................................................................
# Bring it together
#.......................................................................
cowplot::plot_grid(clinplot, genomicplot, ncol = 1,
                   align = "v",
                   rel_heights = c(2, 1)
                   )


