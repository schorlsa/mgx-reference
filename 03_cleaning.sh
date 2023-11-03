# for metaphlan4

#singularity exec --bind /nfs:/nfs /nfs/data/TOOLs/singularity/images/samtools.sif bash ~/mgx-reference/03_cleaning.sh mgx_michael_2023

output_file="progr_info.txt"
if [ -e $output_file ]; then
  echo "File $output_file already exists!"
else
  samtools --version >> $output_file
fi

if [ $? -eq 0 ]; then
    echo "Version information has been written to $output_file"
else
    echo "Failed to retrieve the version information."
fi

prj_name=healthy_enable_2023

sam_dir=/nfs/data/projects/${prj_name}/analysis/metaphlan4/sam

cd $sam_dir;

sample_id_lst=$(ls *.sam | cut -f1 -d"." | sort | uniq)

echo $sample_id_lst

for sample_id in $sample_id_lst 
do
echo $sample_id
sam_fp=${sample_id}.sam
sorted_bam_fp=${sample_id}.sorted.bam
samtools view -u $sam_fp | samtools sort -o $sorted_bam_fp

done

#rm -r ${sam_dir}/*.sam

