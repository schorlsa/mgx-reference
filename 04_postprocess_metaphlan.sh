#process results from metaphlan run

#singularity shell --bind /nfs/data/projects/PCOS_Qi_2019/analysis/metaphlan4/ /nfs/data/TOOLs/singularity/images/metaphlan4.sif
#singularity exec --bind /nfs:/nfs /nfs/data/TOOLs/singularity/images/metaphlan4.sif bash ~/mgx-reference/04_postprocess_metaphlan.sh healthy_enable_2023

#save programme version
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

prj_name=$1
metaphlan_root=/nfs/data/projects/${prj_name}/analysis/metaphlan4

#fix header problem
find ${metaphlan_root}/profile/ -name "*.profile.txt" -type f | xargs sed -i -e '/reads processed/d'
find ${metaphlan_root}/profile/ -name "*.profile.txt" -type f | xargs sed -i -e '/estimated_reads/d'

#generate table of merged abundances from all samples
merge_metaphlan_tables.py ${metaphlan_root}/profile/*.profile.txt > ${metaphlan_root}/analysis/merged_abundance_table.txt

#prepare for visualisation
#species level
grep -E "s__|profile" ${metaphlan_root}/analysis/merged_abundance_table.txt | grep -E -v "t__" | sed 's/^.*s__//g'| sed -e 's/clade_name/bacterial_species/g' > ${metaphlan_root}/analysis/merged_abundance_table_species.txt

#phylum level
grep -E "p__|profile" ${metaphlan_root}/analysis/merged_abundance_table.txt | grep -E -v "c__" | sed 's/^.*p__//g'| sed -e 's/clade_name/bacterial_phylum/g' > ${metaphlan_root}/analysis/merged_abundance_table_phylum.txt

#genus level
grep -E "g__|profile" ${metaphlan_root}/analysis/merged_abundance_table.txt | grep -E -v "s__" | sed 's/^.*g__//g'| sed -e 's/clade_name/bacterial_genus/g' > ${metaphlan_root}/analysis/merged_abundance_table_genus.txt

#grep: search for expression s__ or clade
#only extract species name, cut off the rest (replace by nothing)
#replace name of first column by bacterial_species


