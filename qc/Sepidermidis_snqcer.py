###############################################################################
# Purpose:  SnakeMake File TEMPLATE to check for Coverage and QC on the Bam files
# Authors: Nick Brazeau  & Dayne Filer   & Christian Parobek
#Given: Realn.Bam
#Return: coverage, qc
#Remarks: As before, you will need to change your paths
#      	  There is a clash issue with snakemake using python 3 and multiqc python 2. Need to run from command line
#		  Note, the heatmap coverage plot and the bed map plot are not very generalizable and need to be updated. Don't use...depreciated and not up to date at this time
###############################################################################


####### Working Directory and Project Specifics ############
workdir: '/pine/scr/n/f/nfb/Projects/Sepi_Res_CaseStudy/'
readdir = '/pine/scr/n/f/nfb/Projects/Sepi_Res_CaseStudy/wgs_pe_improved/aln/merged/'
SAMPLES, = glob_wildcards(readdir + '{sample}.bam')


################   REFERENCE    ##############
REF = '/proj/ideel/resources/genomes/Sepidermidis/genomes/CORE_GCF_000007645.1_ASM764v1_genomic.fasta'
GFF = '/proj/ideel/resources/genomes/Sepidermidis/info/gff/GCF_000007645.1_ASM764v1_genomic.gff'
##########################################################################################

############################
####### Target #############
############################
#Rule all checks to see if file is the same and follows directions up to specified point
rule all:
# SUMMARYSTATS
#	input: expand('SumSTATsandQC/ValidateBAM/{sample}.validatebams.txt', sample = SAMPLES)
#	input: expand('SumSTATsandQC/AlignSummary/{sample}.AlignSummary.Metrics', sample = SAMPLES)
#	input: expand('SumSTATsandQC/FlagStats/{sample}.samtools.flagstats', sample = SAMPLES)
#	input: expand('SumSTATsandQC/coverage/data/{sample}.long.cov', sample = SAMPLES)
   input: expand('SumSTATsandQC/CallableLoci/{sample}_callable_status.bed', sample = SAMPLES)
###############################################################################



######################################
########   Quality Control   #########
#####################################

rule CallableLoci_By_SAMPLE:
	input: bams = 'wgs_pe_improved/aln/merged/{sample}.bam',
	output: bedfile = 'SumSTATsandQC/CallableLoci/{sample}_callable_status.bed', summarytable = 'SumSTATsandQC/CallableLoci/{sample}_summarytable.txt'
	shell: 'java -jar /nas/longleaf/apps/gatk/3.8-0/GenomeAnalysisTK.jar -T CallableLoci \
		-R {REF} \
		-I {input.bams} \
		--minBaseQuality 30 \
		--minMappingQuality 55 \
		-summary {output.summarytable} \
		-o {output.bedfile}'
# Min depth means If the number of QC+ bases (on reads with MAPQ > minMappingQuality and with base quality > minBaseQuality) exceeds this value and is less than maxDepth the site is considered PASS.
# NOTE this tool has other default parameters discussed here: https://software.broadinstitute.org/gatk/gatkdocs/3.7-0/org_broadinstitute_gatk_tools_walkers_coverage_CallableLoci.php


rule calculate_cov_forplots:
	input:	'wgs_pe_improved/aln/merged/{sample}.bam'
	output:	'SumSTATsandQC/coverage/data/{sample}.long.cov'
	shell:	'bedtools genomecov \
		-ibam {input} -d | grep "Chromosome" \
		> {output}'

rule summary_stats:
	input: 'wgs_pe_improved/aln/merged/{sample}.bam'
	output: 'SumSTATsandQC/FlagStats/{sample}.samtools.flagstats'
	shell: 'samtools flagstat {input} > {output}'
# Provides alignment information

rule AlignSummaryMetrics:
	input: 'wgs_pe_improved/aln/merged/{sample}.bam'
	output: 'SumSTATsandQC/AlignSummary/{sample}.AlignSummary.Metrics'
	shell: 'picard CollectAlignmentSummaryMetrics \
          R={REF} \
          I={input} \
          O={output}'
# Need this for read length averages, etc.

rule ValidateSamFile:
	input:'wgs_pe_improved/aln/merged/{sample}.bam'
	output: 'SumSTATsandQC/ValidateBAM/{sample}.validatebams.txt'
	shell: 'picard ValidateSamFile \
	    MODE=SUMMARY \
		I={input} > {output}'
	# After this step you should run from the command line `cat 'SumSTATsandQC/ValidateBams.tab.txt | grep "ERROR"` -- if there are errors, STOP and figure out why
