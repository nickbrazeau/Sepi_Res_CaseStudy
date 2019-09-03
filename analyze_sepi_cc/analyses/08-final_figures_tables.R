#----------------------------------------------------------------------------------------------------
# Purpose of this script is to make final figures and tables
#----------------------------------------------------------------------------------------------------


#..........................................
# CIRCOS Plot
#..........................................
circ_wsaf_plot <- readRDS("~/Documents/GitHub/Sepi_Res_CaseStudy/analyze_sepi_cc/figures/circ_wsaf_plot.RDS")
circ_gt_plot <- readRDS("~/Documents/GitHub/Sepi_Res_CaseStudy/analyze_sepi_cc/figures/circ_gt_plot.RDS")

svglite::svglite(file = "figures/combined_circos_plot.svg",
                 width = 11, height = 7)
cowplot::plot_grid(circ_wsaf_plot, circ_gt_plot,
                   align = "h",
                   labels = c("(A)", "(B)"), label_size = 12)
graphics.off()

#..........................................
# Structural Variant Supp Tables
#..........................................
load("~/Documents/GitHub/Sepi_Res_CaseStudy/analyze_sepi_cc/data/lumpy_raw_filt.RDA")
readr::write_csv(x = passSV,
                 path = "tables/passed_StructuralVars.csv")


#..........................................
# CGE Table
#..........................................
load("~/Documents/GitHub/Sepi_Res_CaseStudy/analyze_sepi_cc/data/derived_data/GEtools_table_outputs.RDA")

cgetable.fx.plasmids$plasmids <- unlist(cgetable.fx.plasmids$plasmids)
readr::write_csv(x = cgetable.fx.plasmids,
          path = "tables/cge_tools_table.csv")


#..........................................
# Biofilms KMA Table
#..........................................
kmabiofilm.res <- readRDS("~/Documents/GitHub/Sepi_Res_CaseStudy/analyze_sepi_cc/data/derived_data/biofilms_kma_output.RDS")


readr::write_csv(x = kmabiofilm.res,
                 path = "tables/kma_biofoilms_table.csv")
