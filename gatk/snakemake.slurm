#!/bin/bash
#SBATCH -n 1
#SBATCH -t 1-00:00:00
#SBATCH --mem 1g
#SBATCH -o %A_Sepidermidis_res.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nbrazeau@med.unc.edu

snakemake -s sepidermidis_snvarianter.py --cluster "sbatch -n1 -t 1-00:00:00 --mem 49152 -o Cluster_%A_job.out" -j 4
