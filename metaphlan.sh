#process results from metaphlan run


#fix header problem
find profile/ -name "*.profile.txt" -type f | xargs sed -i -e '/reads processed/d'
find profile/ -name "*.profile.txt" -type f | xargs sed -i -e '/estimated_reads/d'

#generate table of merged abundances from all samples
merge_metaphlan_tables.py profile/*.profile.txt > merged_abundance_table.txt

#prepare for visualisation
#grep -E "s__|clade" merged_abundance_table.txt | grep -E -v "t__" merged_abundance_table.txt | sed 's/^.*s__//g'| sed -e 's/clade_name/bacterial_species/g' > test_merged_abundance_table_species.txt

#species level
grep -E "s__|profile" merged_abundance_table.txt | grep -E -v "t__" | sed 's/^.*s__//g'| cut -f1,3-42 | sed -e 's/clade_name/bacterial_species/g' > merged_abundance_table_species.txt

#phylum level
grep -E "p__|profile" merged_abundance_table.txt | grep -E -v "c__" | sed 's/^.*p__//g'| cut -f1,3-42 | sed -e 's/clade_name/bacterial_phylum/g' > merged_abundance_table_phylum.txt

#phylum level
grep -E "g__|profile" merged_abundance_table.txt | grep -E -v "s__" | sed 's/^.*g__//g'| cut -f1,3-42 | sed -e 's/clade_name/bacterial_genus/g' > merged_abundance_table_genus.txt

#grep: search for expression s__ or clade
#only extract species name, cut off the rest (replace by nothing)
#replace name of first column by bacterial_species


