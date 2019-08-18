#!/bin/bash
#SBATCH -n 1
#SBATCH -t 1-00:00:00
#SBATCH --mem 50g
#SBATCH -o %A_Sepidermidis_res.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nbrazeau@med.unc.edu

snakemake -s mask_regions_snfilter.py
