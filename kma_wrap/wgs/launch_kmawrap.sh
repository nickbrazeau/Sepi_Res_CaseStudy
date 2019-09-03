#! /bin/bash

ROOT=<path> # root directory for project (non-scratch)
WD=<path> # working directory for results (scratch)
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
