#!/usr/bin/python3
###############################################################################
# Purpose: Smooth lumpy/svtyper calling for Sepi project
# Author: Nick Brazeau
#Given: Bam
#Return: VCF
###############################################################################


####### Working Directory and Project Specifics ############
workdir: '/Users/nickbrazeau/Documents/GitHub/Sepi_Res_CaseStudy/smoothlumpy/bams/'
bamrefdir = '/Users/nickbrazeau/Documents/GitHub/Sepi_Res_CaseStudy/smoothlumpy/bams/'
SAMPLES, = glob_wildcards(bamrefdir + '{sample}.bam')


# docker pull brentp/smoove
# docker run -it brentp/smoove smoove -h

#############################
#######  RULE ALL  ##########
#############################
rule all:
#	input: 'smoothcaller.log'
#	input: 'sepi_clincases-smoove.genotyped.dupdel.pass.vcf.gz'
	input: 'sepi_clincases-smoove.genotyped.bndinv.pass.vcf.gz'

rule filter_smooth_vcf_for_bndinv:
	input: 'sepi_clincases-smoove.genotyped.vcf.gz'
	output: 'sepi_clincases-smoove.genotyped.bndinv.pass.vcf.gz'
	shell: '''bcftools view -i \
			'(SVTYPE = "BND" & FMT/DP > 100) | (SVTYPE = "INV" & FMT/DP > 100)' \
			{input} | bgzip -c > {output}'''

rule filter_smooth_vcf_for_dupdels:
	input: 'sepi_clincases-smoove.genotyped.vcf.gz'
	output: 'sepi_clincases-smoove.genotyped.dupdel.pass.vcf.gz'
	shell: '''bcftools view -i \
			'(SVTYPE = "DEL" & FMT/DHFFC[0] < 0.7) | (SVTYPE = "DUP" & FMT/DHBFC[0] > 1.3)' \
			{input} | bgzip -c > {output}'''

rule smooth_operator_call:
	input: expand('{samples}.bam', samples = SAMPLES)
	#params: expand(samp = '{samples}',
	output: log = 'smoothcaller.log'
	shell: 'docker run -it \
			-v {bamrefdir}:/work/ \
			brentp/smoove:v0.2.3 smoove call --duphold --removepr \
			--name sepi_clincases --fasta CORE_GCF_000007645.1_ASM764v1_genomic.fasta --genotype {input} 2> {output.log}'

# On Aug 19, 2019, the latest branch appeared to have a python2/3 conflict. Saw
# that this was changed two days ago. I reverted to the previous version which
# works for my environment. I didn't notice any big version achanges from v0.2.3 -> 0.2.4
# other than the python switch
