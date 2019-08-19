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
	input: 'smoothcaller.log'



# rule smooth_operator_merge:
# 	input:
# 	output:
# 	shell: 'docker run -it brentp/smoove smoove merge \
# 	'

rule smooth_operator_call:
	input: expand('{samples}.bam', samples = SAMPLES)
	#params: expand(samp = '{samples}',
	output: log = 'smoothcaller.log'
	shell: 'docker run -it \
			-v {bamrefdir}:/work/ \
			brentp/smoove smoove call --duphold --removepr \
			--name sepi_clincases --fasta CORE_GCF_000007645.1_ASM764v1_genomic.fasta --genotype {input} 2> {output.log}'

# TODO look at the -x and -d flags
