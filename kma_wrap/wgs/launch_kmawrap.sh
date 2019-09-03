#! /bin/bash

ROOT=/proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/kma_wrap/wgs/ # root directory for project (non-scratch)
WD=/pine/scr/n/f/nfb/Projects/Sepi_Res_CaseStudy/kma_wrap/ # working directory for results (scratch)
NODES=1028 # max number of cluster nodes
WAIT=30 # number of seconds to wait for files to appear, absorbing some file system latency

snakemake \
	--snakefile $ROOT/kma_wrapper.snake \
	--configfile config_kma.yaml \
	--printshellcmds \
	--directory $WD \
	--cluster $ROOT/launch.py \
	-j $NODES \
	--rerun-incomplete \
	--keep-going \
	--latency-wait $WAIT \
	--dryrun -p
