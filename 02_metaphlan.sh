#MetaPhlAn 3 and 4

#docker run --group-add 1002 -v /nfs:/nfs  -it biobakery/metaphlan:3.0.1 
#
#prj_name=Healthy_LokmerA_2019
#R1_suffix=_R1.fq.gz
#R2_suffix=_R2.fq.gz
#
#mgx_cleaned_dir=/nfs/data/projects/${prj_name}/QC/mgx_cleaned
#metaphlan3_root=/nfs/data/projects/${prj_name}/analysis/metaphlan3
#profile_dir=${metaphlan3_root}/profile
#sam_dir=${metaphlan3_root}/sam
#analysis_dir=${metaphlan3_root}/analysis
#
#mkdir -p ${profile_dir}
#mkdir -p ${sam_dir}
#mkdir -p ${analysis_dir}
#
#sample_id_lst=$(ls ${mgx_cleaned_dir}/*${R1_suffix}* | cut -f8 -d'/' | sort | uniq)
#
#for cur_sample_id in $sample_id_lst 
#do
#	echo @@@@@
#	cur_sample_id=${cur_sample_id%${R1_suffix}}
#	echo $cur_sample_id;
#	rm -f stdin_map.bowtie2out.txt;
#	FILE=${profile_dir}/${cur_sample_id}.profile.txt
#	echo $FILE
#	[[ -f $FILE ]] && echo "$FILE exists." && continue
#	echo "running $FILE"
#	zcat ${mgx_cleaned_dir}/${cur_sample_id}${R1_suffix} ${mgx_cleaned_dir}/${cur_sample_id}${R2_suffix} | metaphlan -t rel_ab_w_read_stats --nproc 20 --input_type fastq -t rel_ab_w_read_stats -s ${sam_dir}/${cur_sample_id}.sam  > ${profile_dir}/${cur_sample_id}.profile.txt;
#done



### now version 4 [MetaPhlAn version 4.0.2 (22 Sep 2022)]

echo "Running with parameter: $1"

metaphlan --version
#prj_name=PCOS_Qi_2019
prj_name=$1
R1_suffix=_R1.fq.gz
R2_suffix=_R2.fq.gz

mgx_cleaned_dir=/nfs/data/projects/${prj_name}/QC/mgx_cleaned
metaphlan4_root=/nfs/data/projects/${prj_name}/analysis/metaphlan4
metaphlan4_DB_dir=/nfs/data/database/metaphlan4_DB

profile_dir=${metaphlan4_root}/profile
analysis_dir=${metaphlan4_root}/analysis
sam_dir=${metaphlan4_root}/sam

sample_id_lst=$(ls ${mgx_cleaned_dir}/*${R1_suffix} | cut -f8 -d'/' | cut -f1 -d'_' | sort | uniq)

for cur_sample_id in $sample_id_lst 
do
	echo @@@@@
	echo $cur_sample_id;
	rm -f stdin_map.bowtie2out.txt;
	FILE=${profile_dir}/${cur_sample_id}.profile.txt
	# echo $FILE
	[[ -f $FILE ]] && echo "$FILE exists." && continue
	echo "running $FILE"
	zcat ${mgx_cleaned_dir}/${cur_sample_id}${R1_suffix} ${mgx_cleaned_dir}/${cur_sample_id}${R2_suffix} | \
		metaphlan -x mpa_vJan21_CHOCOPhlAnSGB_202103 --bowtie2db ${metaphlan4_DB_dir}  -t rel_ab_w_read_stats \
		--nproc 20 --input_type fastq -t rel_ab_w_read_stats -s ${sam_dir}/${cur_sample_id}.sam  > ${profile_dir}/${cur_sample_id}.profile.txt;
done

echo "MetaPhlAn run done"
metaphlan --version

#write metaphlan version to output file
output_file="progr_info.txt"
if [ -e $output_file ]; then
  echo "File $output_file already exists!"
else
  metaphlan --version >> $output_file
fi

if [ $? -eq 0 ]; then
    echo "Version information has been written to $output_file"
else
    echo "Failed to retrieve the version information."
fi
