# Reproducibility

In order to recreate the bioinformatics and analyses
completed in the Manuscript Brazeau & Levinson _et al._ 2019,
you will need to run the two "pipelines" below:


### Referent Guided Alignments/WGS
1. Alignment (wgs_pe_improved)
2. Quality Control/Quality Analysis (qc)
3. Short variant Calling (gatk)
4. Run Structural Variant Discovery (smoothlumpy)
5. Variant Filtration (make_regions)



###  _de novo_ Assembly/CGE pipeline
1. Run [CGE](http://www.genomicepidemiology.org/) submodules (except plasmidfinder) (CGEtools_noplasmidfinder)
2. Run Plasmidfinder (plasmidfinder_tools)


#### Dependencies
* `bwa-mem` version 0.7.17
* `cutadapt` version 2.3
* `samblaster` version 0.1.24
* `samtools` version 1.9
* `Picard Tools` version 2.20.3
* `bedtools` version 2.28.0
* `GATK` version 4.0.3.0
* `GATK` version 3.8.0 (For the `CallableLoci` and `VariantAnnotator` tools)
* `snpEFF` version 4.3t
* `smoove` version 0.2.3
* `bcftools` version 1.9
* [CGE Tools Pipeline Docker Image](https://bitbucket.org/genomicepidemiology/cge-tools-docker/src/master/)
* [PlasmidFinder](https://bitbucket.org/genomicepidemiology/plasmidfinder/src/master/)
