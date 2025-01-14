
# mkdir
mkdir ../results/e.functional_profile/
mkdir ../results/e.functional_profile/prepare

#install picrust2
#Download the source tarball, untar, and move into directory. You can check that you are downloading the latest release here: https://github.com/picrust/picrust2/releases

#  ======= prepare the data picrust2 need
# The input files should be a FASTA of amplicon sequences variants (ASVs; i.e. your representative sequences, not your raw reads, which is study_seqs.fna below) 
# and a BIOM table of the abundance of each ASV across each sample (study_seqs.biom below). 
# Note that a tab-delimited table with ASV ids as the first column and sample abundances as all subsequent columns will also work.

qiime tools export \
     --input-path  ../results/c.diversity_ana/core-metrics-results/rarefied_table.qza \
     --output-path ../results/e.functional_profile/prepare

qiime tools export \
     --input-path  ../results/b.feature_table/filtered-rep-seqs.qza \
     --output-path ../results/e.functional_profile/prepare

# activate
conda activate picrust2 

picrust2_pipeline.py -s ../results/e.functional_profile/prepare/dna-sequences.fasta 
-i ../results/e.functional_profile/prepare/feature-table.biom 
-o ../results/e.functional_profile/picrust2_out_pipeline -p 6 --stratified --remove_intermediate --verbose

# locate description_mapfiles
# Picrust2 + aldex2

 




