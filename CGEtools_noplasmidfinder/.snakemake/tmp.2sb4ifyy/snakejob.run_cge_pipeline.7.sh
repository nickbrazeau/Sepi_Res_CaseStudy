#!/bin/sh
# properties = {"type": "single", "rule": "run_cge_pipeline", "local": false, "input": ["/proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/symlinks/Sepi01_5_22_2018_R1.fastq.gz", "/proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/symlinks/Sepi01_5_22_2018_R2.fastq.gz"], "output": ["/proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/CGEtools_noplasmidfinder/Sepi01_5_22_2018", "/proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/CGEtools_noplasmidfinder/Sepi01_5_22_2018.txt"], "wildcards": {"fastq": "Sepi01_5_22_2018"}, "params": {}, "log": [], "threads": 1, "resources": {}, "jobid": 7, "cluster": {}}
cd /proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/CGEtools_noplasmidfinder && \
/nas/longleaf/home/nfb/.linuxbrew/opt/python/bin/python3.7 \
-m snakemake /proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/CGEtools_noplasmidfinder/Sepi01_5_22_2018.txt --snakefile /proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/CGEtools_noplasmidfinder/run_CGEtools.snake.py \
--force -j --keep-target-files --keep-remote \
--wait-for-files /proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/CGEtools_noplasmidfinder/.snakemake/tmp.2sb4ifyy /proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/symlinks/Sepi01_5_22_2018_R1.fastq.gz /proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/symlinks/Sepi01_5_22_2018_R2.fastq.gz --latency-wait 5 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --no-hooks --nolock --mode 2  --allowed-rules run_cge_pipeline  && touch "/proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/CGEtools_noplasmidfinder/.snakemake/tmp.2sb4ifyy/7.jobfinished" || (touch "/proj/ideel/meshnick/users/NickB/Projects/Sepi_Res_CaseStudy/CGEtools_noplasmidfinder/.snakemake/tmp.2sb4ifyy/7.jobfailed"; exit 1)

