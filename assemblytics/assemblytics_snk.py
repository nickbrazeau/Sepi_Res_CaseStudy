#!/usr/bin/python3
###############################################################################
# Purpose: Running assembyltics for Sepi
# Author: Nick Brazeau
#Given: ref fasta, velvet alginment
#Return: assemblytics output
#Notes: this is a very basic script that is using wildcards instead of a "master" head file
###############################################################################

####### Working Directory and Project Specifics ############
workdir: '/pine/scr/n/f/nfb/Projects/Sepi_Res_CaseStudy/assemblytics'
readdir = '/pine/scr/n/f/nfb/Projects/Sepi_Res_CaseStudy/wgs_pe_improved/aln/merged/'
SAMPLES, = glob_wildcards(readdir + '{sample}.bam')

########   REFERENCE & Assemb. Paths   ##############
REF = '/proj/ideel/resources/genomes/Sepidermidis/genomes/CORE_GCF_000007645.1_ASM764v1_genomic.fasta'
GFF = '/proj/ideel/resources/genomes/Sepidermidis/info/gff/GCF_000007645.1_ASM764v1_genomic.gff'
ASSEMB = '/nas/longleaf/home/nfb/bin/Assemblytics/scripts/Assemblytics'

rule all:
	input: expand('logs/{sample}_assembly.log', sample = SAMPLES)


# Run Assemblytics https://github.com/MariaNattestad/Assemblytics
# anchor is default at 10kbp
# 2499279 is the size of the whole genome
# note the input for the Assemblytics program is a command line parsing
rule run_assemlytics:
	input: 'logs/{sample}_nucmer_assembly.log'
	params: '{sample}'
	output: 'logs/{sample}_assembly.log'
	shell: '{ASSEMB} {params}.delta {params} 10000 50 2499279 2> {output}'

rule run_nucmer:
    input: '/proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/CGEtools_noplasmidfinder/{sample}_5_22_2018/Assembler/output/assembly/contigs.fa'
    params: '{sample}'
    output: 'logs/{sample}_nucmer_assembly.log'
    shell: 'nucmer --maxmatch -minmatch 100 -mincluster 500 \
    {REF} \
    {input} \
    --prefix={params}  2> {output}'
