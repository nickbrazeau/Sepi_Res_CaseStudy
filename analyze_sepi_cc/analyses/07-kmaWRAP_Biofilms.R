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


#.............................................................................
# Make Fasta of Biofilm Genes
#.............................................................................
fa <- Biostrings::readDNAStringSet(file = "~/Documents/MountPoints/mountIDEEL/resources/genomes/Sepidermidis/genomes/CORE_GCF_000007645.1_ASM764v1_genomic.fasta")

ret <- c()
for(i in 1:nrow(gff.biofilm)){
  temp <- fa[[1]][gff.biofilm$start[i] : gff.biofilm$end[i] ]
  ret <- c(ret, temp)
}
names(ret) <- toupper(gff.biofilm$genenames)


#.............................................................................
# Write out fasta
#.............................................................................

seqinr::write.fasta(sequences = ret,
                    names = names(ret),
                    file.out = "~/Documents/GitHub/Sepi_Res_CaseStudy/kma_wrap/biofilm_gene_candidates/biofilm_gene_candidates.fasta")


#.............................................................................
# RUN KMA
#.............................................................................
# system(call)

#.............................................................................
# Read in KMA results
#.............................................................................




