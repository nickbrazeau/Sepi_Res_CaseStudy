#!/usr/bin/python3
###############################################################################
# Purpose: Running assembyltics for Sepi
# Author: Nick Brazeau
#Given: fasta, vcf, etc
#Return: bed, vcf
###############################################################################

####### Working Directory and Project Specifics ############
workdir: '/pine/scr/n/f/nfb/Projects/Sepi_Res_CaseStudy/assemblytics'
readdir = '/pine/scr/n/f/nfb/Projects/Sepi_Res_CaseStudy/wgs_pe_improved/aln/merged/'
SAMPLES, = glob_wildcards(readdir + '{sample}.bam')

########   REFERENCE & Assemb. Paths   ##############
REF = '/proj/ideel/resources/genomes/Sepidermidis/genomes/CORE_GCF_000007645.1_ASM764v1_genomic.fasta'
GFF = '/proj/ideel/resources/genomes/Sepidermidis/info/gff/GCF_000007645.1_ASM764v1_genomic.gff'
{ASSEMB} = '/nas/longleaf/home/nfb/bin/Assemblytics/scripts/ Assemblytics'

rule all:
	input: expand('nucmer/{sample}_nucmer.log', sample = SAMPLES)


# Run Assemblytics https://github.com/MariaNattestad/Assemblytics
rule run_

rule run_nucmer:
    input: '/proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/CGEtools_noplasmidfinder/{sample}_5_22_2018/Assembler/output/assembly/contigs.fa'
    param: '{sample}'
    output: 'nucmer/{sample}_nucmer.log'
    shell: 'nucmer --maxmatch -minmatch 100 -mincluster 500 \
    {REF} \
    {input} \
    --prefix={param}  2> {output} '
