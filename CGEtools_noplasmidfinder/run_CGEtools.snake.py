#!/usr/bin/python3
###############################################################################
# Purpose: Run CGEtools
# Author: Nick Brazeau
#Given: fastq
#Return: cge-pipeline-output


###############################################################################


####### Working Directory and Project Specifics ############
workdir: '/proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/CGEtools_noplasmidfinder/'
bamdir = '/pine/scr/n/f/nfb/Projects/Sepi_Res_CaseStudy/wgs_pe_improved/aln/merged/'
symlinksdir = '/proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/symlinks/'

FASTQS, = glob_wildcards(symlinksdir + '{fastq}_R2.fastq.gz')


# Set SIMG path
SIMG_PATH='/proj/ideel/bin/CGE_Pipeline/sandeep_backup/simg/cgetools-20181107.simg'
# Set working directory path
OUT_PATH='/proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/CGEtools_noplasmidfinder/'
# set the data base database path
DBPATH='/proj/ideel/resources/BacterialDatabases_CGE/'
##########################################################################################


rule all:
	input: expand(OUT_PATH + '{fastq}' + "/" + '{fastq}' + '.setup.txt', fastq = FASTQS)
#	input: expand(OUT_PATH + '{fastq}' + '.txt', fastq = FASTQS)




rule run_cge_pipeline:
	input: fq1 = symlinksdir + '{fastq}_R1.fastq.gz', fq2 = symlinksdir + '{fastq}_R2.fastq.gz',
	output: path = OUT_PATH + '{fastq}', summ = OUT_PATH + '{fastq}' + '.txt',
	shell: 'singularity exec -B /proj/ -B /pine/scr/n/f/nfb/ -B {DBPATH}:/cgetmp/databases \
			{SIMG_PATH} bash -c "export CGEPIPELINE_DB=/cgetmp/databases; \
			cd {output.path}; BAP --services KmerFinder,MLST,ResFinder \
			--fq1 {input.fq1} --fq2 {input.fq2}  --Asp Illumina --Ast paired" \
			; echo "sample complete" > {output.summ}'
# Note, as of 8/21/19, VirulenceFinder only supports:
# Listeria, S. aureus, E. coli, enterococcus (e.g. no staph epi, so BAP won't run it)
# Note, as of 8/21/19 cgMLSTFinder only supports:
# Campylobacter, clostridium, E. coli, Listeria, Salmonella, Yersinia (e.g. gram-negs)
# no, staph epi to consider, dropping

rule setup_output_dir_for_singularity:
	output: summ = OUT_PATH + '{fastq}' + "/" + '{fastq}' + '.setup.txt',
	shell: 'echo "sample complete" > {output.summ}'
