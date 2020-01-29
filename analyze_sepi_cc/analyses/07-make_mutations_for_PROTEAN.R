#----------------------------------------------------------------------------------------------------
# Purpose of this script is to make the mutations that we found
# and have been previously published in the literature for the
# WalK gene
#----------------------------------------------------------------------------------------------------

#...........................
# Convert GFF to df
#...........................
gff <- "~/Documents/MountPoints/mountIDEEL/resources/genomes/Sepidermidis/info/gff/GCF_000007645.1_ASM764v1_genomic.gff"

geneid.end <- grep('##FASTA',readLines(gff))
geneid.gff <- read.delim(file = gff,
                         nrows = geneid.end-1, comment= "#", header=F)
colnames(geneid.gff) <- c("seqname", "source", "feature", "start", "end", "score", "strand", "frame", "info")
geneid.gff <- subset(geneid.gff, geneid.gff$feature == "gene") # subset to only genes, don't want the other mRNA, etc data
geneid.gff$GeneID <- stringr::str_split_fixed(geneid.gff$info, ";", n=2)[,1] # give it to columns to parse on
geneid.gff$GeneID <- gsub("ID=", "", geneid.gff$GeneID, fixed=T)


#...........................
# Subset Gene of interest from GFF
#...........................
# Note, know gene20 from 03-Short_Var_Filtered for the annotations section
walk.df <- data.frame(geneid.gff[geneid.gff$GeneID == "gene20", ], stringsAsFactors = F)

# read in gff fasta
gffseq <- seqinr::read.fasta(file=gff, seqtype = c("DNA"), forceDNAtolower = F, strip.desc = T)
# subset
gffseq <- gffseq[names(gffseq) == "NC_004461.1"] # genomic DNA

# pull out walk seq based on coordinates
# GFF are 1-based
walk.seq.ref <- gffseq$NC_004461.1[walk.df$start:walk.df$end]
seqinr::write.fasta(sequences = paste(seqinr::translate(walk.seq.ref), collapse = ""),
                    names = "walK", file.out = "../provean_analysis/sepi_walk_gene.fna")


#...........................
# Our Study Mutations
#...........................
# VCFs are also 1-based, so this can down directly
#CHROM	POS	REF	ALT	SNPEFF_AMINO_ACID_CHANGE	SNPEFF_CODON_CHANGE	SNPEFF_EFFECT	SNPEFF_EXON_ID	SNPEFF_FUNCTIONAL_CLASS	SNPEFF_GENE_BIOTYPE	SNPEFF_GENE_NAME	SNPEFF_IMPACT	SNPEFF_TRANSCRIPT_ID	info	GeneID	Description
# 1	Chromosome	26722	GAAC	G		2055	UPSTREAM		NONE	protein_coding	SE_0021	MODIFIER	AAO03618	ID=gene20;Dbxref=GeneID:1056847;Name=SE0019;gbkey=Gene;gene_biotype=protein_coding;locus_tag=SE0019	gene20	Name=SE0019
# 2	Chromosome	26858	C	T	P415L 	cCa/cTa	NON_SYNONYMOUS_CODING	1	MISSENSE	protein_coding	SE_0019	MODERATE	AAO03616	ID=gene20;Dbxref=GeneID:1056847;Name=SE0019;gbkey=Gene;gene_biotype=protein_coding;locus_tag=SE0019	gene20	Name=SE0019

walk.seq.mut.ourstudy <- walk.seq.ref
# need to change global to local
s1int <- 26722 - walk.df$start + 1 # perserve 1-base
s2int <- 26858 - walk.df$start + 1 # perserve 1-base
walk.seq.mut.ourstudy[s1int:(s1int+3)] <- c("G", NA, NA, NA)
walk.seq.mut.ourstudy[s2int] <- "T"
seqinr::translate(walk.seq.mut.ourstudy)[415]
# now get rid of deletion
walk.seq.mut.ourstudy <- walk.seq.mut.ourstudy[!is.na(walk.seq.mut.ourstudy)]

seqinr::translate(walk.seq.ref)[369:375]
seqinr::translate(walk.seq.mut.ourstudy)[369:375]
# even though the deletion crosses multiple amino acid codons, it
# still only encodes a single AA deletion

#...........................
# Write out DNA and AA Fasta
#...........................
seqinr::write.fasta(sequences = walk.seq.mut.ourstudy,
                    names = c("Brazeau_haplotype"),
                    file.out = "../provean_analysis/SEpi_mutated_haplotypes.fa")


seqinr::write.fasta(sequences = seqinr::translate(walk.seq.mut.ourstudy),
                    names = c("Brazeau_haplotype"),
                    file.out = "../provean_analysis/SEpi_mutated_haplotypes.fna")


seqinr::write.fasta(sequences = walk.seq.ref,
                    names = c("Ref_haplotype"),
                    file.out = "../provean_analysis/SEpi_ref_haplotypes.fa")


seqinr::write.fasta(sequences = seqinr::translate(walk.seq.ref),
                    names = c("Ref_haplotype"),
                    file.out = "../provean_analysis/SEpi_ref_haplotypes.fna")



#...........................
# How many differences do we have
# exactly between the ref and mut fastas
#...........................
library(Biostrings)
ref.xstring <- Biostrings::AAStringSet(x = paste(seqinr::translate(walk.seq.ref), collapse = ""))
mut.xstring <- Biostrings::AAStringSet(x = paste(seqinr::translate(walk.seq.mut.ourstudy), collapse = ""))

mutref.stringset <- Biostrings::AAStringSet(x = c(ref.xstring, mut.xstring))
names(mutref.stringset) <- c("ref", "mut")
Biostrings::stringDist(x = mutref.stringset, method = "levenshtein")




