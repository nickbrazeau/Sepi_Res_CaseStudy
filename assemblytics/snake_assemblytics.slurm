#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=49512
#SBATCH --time=5-00:00:00
#SBATCH --output=%j.log

snakemake -s assemblytics_snk.py --cluster "sbatch -n 1 --mem=49512 --time=1-00:00:00" -j 8
