#!/usr/bin/python3
###############################################################################
# Purpose: Variant Call for Sepi project
# Author: Nick Brazeau
#Given: Bam
#Return: VCF
# Note, this project has been optimized for GATK 3.8 (older version as 4.0 is now available)
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
#	input: expand('variants/{sample}_HaploCaller.raw.g.vcf', sample = SAMPLES)
	input: expand('variants/{ProjName}_HaploCaller_joint.raw.vcf', ProjName = ProjName)
#	input: expand('variants/{ProjName}_HaploCaller_joint.ann.vcf', ProjName = ProjName)



##########################################################################################
##########################################################################################
#########################           Variant Annotation             #######################
##########################################################################################
##########################################################################################
rule Annotate_POP_SNPeffvariants:
	input: vcf = 'variants/{ProjName}_HaploCaller_joint.pass.vcf',
	       snpeff='variants/{ProjName}_HaploCaller_joint.SnpEff.vcf'
	output: 'variants/{ProjName}_HaploCaller_joint.ann.vcf'
	shell: 'gatk --java-options "-Xmx4g -Xms4g" VariantAnnotator \
		-R {REF} \
		-A SnpEff \
		-V {input.vcf} \
		--snpEffFile {input.snpeff} \
		-o {output}'

rule snpEff_Pop_variants:
	input: vcf = 'variants/{ProjName}_HaploCaller_joint.pass.vcf'
	output: 'variants/{ProjName}_HaploCaller_joint.SnpEff.vcf'
	shell: 'snpEff -v -o gatk Staphylococcus_epidermidis_atcc_12228 {input.vcf} > {output}'

rule select_variants :
	input: 'variants/{ProjName}_HaploCaller_joint.qual.vcf'
	output: 'variants/{ProjName}_HaploCaller_joint.pass.vcf'
	shell: 'gatk --java-options "-Xmx4g -Xms4g" SelectVariants \
		-R {REF} -V {input} -o {output} \
		-select "vc.isNotFiltered()"'

rule filter_variants :
	input: 'variants/{ProjName}_HaploCaller_joint.raw.vcf'
	output: 'variants/{ProjName}_HaploCaller_joint.qual.vcf'
	shell: 'gatk --java-options "-Xmx4g -Xms4g" VariantFiltration \
		-R {REF} \
		-V {input} \
		--filterExpression "MQ < 55.0" \
		--filterName "MQ" \
		--filterExpression "SOR > 2.0" \
		--filterName "SOR" \
		--logging_level ERROR \
		-o {output}'

rule genotype_GVCFs:
	input: 'variants/{ProjName}_HaploCaller_joint.combined.g.vcf'
	output: 'variants/{ProjName}_HaploCaller_joint.raw.vcf'
	shell: 'gatk --java-options "-Xmx4g -Xms4g" GenotypeGVCFs \
		    -R {REF} \
		    --variant {input} \
		    -O {output}'


rule combine_gvcfs:
	input: '/proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/gatk/Sepi_gvcfs.list'
	output: 'variants/{ProjName}_HaploCaller_joint.combined.g.vcf'
	shell: 'gatk --java-options "-Xmx4g -Xms4g" CombineGVCFs \
		    -R {REF} \
		    --variant {input} \
		    -O {output}'



# rule combine_gvcfs:
# 	input: map = '/proj/ideel/meshnick/users/NickB/Projects/Sepidermidis_resistance_hosp/names/Sepi_gvcfs.sample_map',
# 		   intervals = '/proj/ideel/meshnick/users/NickB/Projects/Sepidermidis_resistance_hosp/intervals/chr.intervals'
# 	output: scrtchdir + 'variants/Sepi.genomicsdb'
# 	shell: 'gatk --java-options "-Xmx4g -Xms4g" \
# 		GenomicsDBImport \
# 		--intervals {input.intervals} \
# 		--batch-size 50 \
# 		--sample-name-map {input.map} \
# 		--genomicsdb-workspace-path {output}'
# GenomicsDBImport currently only works with diploid data




rule haplotype_caller:
	input: readdir + '{sample}.bam',
	output: 'variants/{sample}_HaploCaller.raw.g.vcf'
	shell: 'gatk --java-options "-Xmx4g -Xms4g" HaplotypeCaller \
		-R {REF} -I {input} \
		-ploidy 1 \
		-ERC GVCF \
		-O {output} '

#--stand_call_conf 30 \
# This is The minimum phred-scaled confidence threshold at which variants should be called
# This should be taken care of in hard filters. Going to leave everything at default for initial variant calling and then filter down later
