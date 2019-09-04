#.............................................................................
# Purpose of this script was to investiage if there was anything
# interesting in biofilm genes previous identifed by Meric et al. 2018
# https://www.nature.com/articles/s41467-018-07368-7
#.............................................................................

library(tidyverse)
library(rentrez)

#.............................................................................
# First Get Biofilm Genes
#.............................................................................
biofilmsang <- readxl::read_excel("data/derived_data/biofilm_gene_candidates.xlsx") %>%
  dplyr::mutate(gene = tolower(gene)) %>%
  dplyr::filter(grepl("se", gene)) # only SE genes

gff <- vcfRmanip::GFF2VariantAnnotation_Short("~/Documents/MountPoints/mountIDEEL/resources/genomes/Sepidermidis/info/gff/GCF_000007645.1_ASM764v1_genomic.gff")
gff <- gff %>%
  dplyr::mutate(genenames = gsub("Name=", "", Description),
                genenames = tolower(genenames))


gff.biofilm <- gff %>%
  dplyr::filter(genenames %in% biofilmsang$gene)



# VCF IMPORT
rawvcf <- vcfR::read.vcfR("~/Documents/MountPoints/mountedScratchLL/Projects/Sepi_Res_CaseStudy/variants/Sepi_Res_CaseStudy_HaploCaller_joint.raw.vcf", verbose = F)


#.............................................................................
# Make Intersected VCF of Biofilm Genes
#.............................................................................
rawvcf.biofilms <- vcfRmanip::vcfR2SubsetChromPos(vcfRobject = rawvcf,
                                                  chromposbed = gff.biofilm)



# empty vcf

