#!/usr/bin/python3
###############################################################################
# Purpose: Masking Regions for Sepi project
# Author: Nick Brazeau
#Given: fasta, vcf, etc
#Return: bed, vcf
###############################################################################


####### Working Directory and Project Specifics ############
workdir: '/pine/scr/n/f/nfb/Projects/Sepi_Res_CaseStudy/'
readdir = '/pine/scr/n/f/nfb/Projects/Sepi_Res_CaseStudy/wgs_pe_improved/aln/merged/'
SAMPLES, = glob_wildcards(readdir + '{sample}.bam')

################   REFERENCE    ##############
REF = '/proj/ideel/resources/genomes/Sepidermidis/genomes/CORE_GCF_000007645.1_ASM764v1_genomic.fasta'
GFF = '/proj/ideel/resources/genomes/Sepidermidis/info/gff/GCF_000007645.1_ASM764v1_genomic.gff'

TMPDIR = '/pine/scr/n/f/nfb/PicardandGATKscratch'
ProjName = 'Sepi_Res_CaseStudy'
##########################################################################################

#############################
#######  RULE ALL  ##########
#############################


rule all:
    input: "repeatmasker.log"
#    input: "nucmer/nucmer.log"
#     input: "Sepidermidis_resistance_hosp.coords"


##########################################################################################
####################           Identify Low-Complexity Regions             ###############
##########################################################################################

# http://mummer.sourceforge.net/manual/#identifyingrepeats
rule get_coords_from_nucmer:
    input: "Sepi_Res_CaseStudy.delta"
    output: "Sepi_Res_CaseStudy.coords"
    shell: "show-coords -r -B {input} > {output}"

rule run_nucmer:
    output: "nucmer/nucmer.log"
    shell: 'nucmer --maxmatch --nosimplify --prefix=Sepi_Res_CaseStudy {REF} {REF} 2> {output} '

rule run_repeatmasker:
    input: {REF},
    output: 'repeatmasker.log',
    shell: 'RepeatMasker {input} 2> {output}'