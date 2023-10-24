#!/bin/bash

#run with bash 01_prepare_enter_docker.sh healthy_enable_2023 (or any other project name)

#cwd=$(pwd)
#prj_name=$(echo ${cwd} | cut -d'/' -f5)

#prj_name=healthy_enable_2023
prj_name=$1
R1_suffix=_R1.fq.gz
R2_suffix=_R2.fq.gz

mgx_cleaned_dir=/nfs/data/projects/${prj_name}/QC/mgx_cleaned
metaphlan4_root=/nfs/data/projects/${prj_name}/analysis/metaphlan4
#metaphlan4_root=${cwd}
metaphlan4_DB_dir=/nfs/data/database/metaphlan4_DB

profile_dir=${metaphlan4_root}/profile
analysis_dir=${metaphlan4_root}/analysis
sam_dir=${metaphlan4_root}/sam

mkdir -p ${profile_dir}
mkdir -p ${sam_dir}
mkdir -p ${analysis_dir}

#docker run --user "$(id -u):$(id -g)" -v /nfs:/nfs -it biobakery/metaphlan bash /nfs/data/projects/${prj_name}/mgx-reference/02_metaphlan.sh
docker run --user "$(id -u):$(id -g)" -v /nfs:/nfs -it biobakery/metaphlan bash ~/mgx-reference/02_metaphlan.sh $prj_name
