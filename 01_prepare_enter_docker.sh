prj_name=PCOS_Qi_2019
R1_suffix=_R1.fq.gz
R2_suffix=_R2.fq.gz

mgx_cleaned_dir=/nfs/data/projects/${prj_name}/QC/mgx_cleaned
metaphlan4_root=/nfs/data/projects/${prj_name}/analysis/metaphlan4
metaphlan4_DB_dir=/nfs/data/database/metaphlan4_DB

profile_dir=${metaphlan4_root}/profile
analysis_dir=${metaphlan4_root}/analysis
sam_dir=${metaphlan4_root}/sam

mkdir -p ${profile_dir}
mkdir -p ${sam_dir}
mkdir -p ${analysis_dir}

#docker run --group-add 1002 -v /nfs:/nfs -it biobakery/metaphlan
docker run --user "$(id -u):$(id -g)" -v /nfs:/nfs -it biobakery/metaphlan


