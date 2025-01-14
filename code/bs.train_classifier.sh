# This script was used to train self-classifier, you can also use the previously trained classifier available from QIIME2.

# primer1 = "CCTAYGGGRBGCASCAG"
# primer2 = "GGACTACNNGGGTATCTAAT"
# Training the Classifier
# download new silva

qiime rescript get-silva-data \
    --p-version '138.1' \
    --p-target 'SSURef_NR99' \
    --p-include-species-labels \
    --o-silva-sequences silva-138.1-ssu-nr99-rna-seqs.qza \
    --o-silva-taxonomy silva-138.1-ssu-nr99-tax.qza


qiime rescript reverse-transcribe \
    --i-rna-sequences silva-138.1-ssu-nr99-rna-seqs.qza \
    --o-dna-sequences silva-138.1-ssu-nr99-seqs.qza


qiime rescript cull-seqs \
    --i-sequences silva-138.1-ssu-nr99-seqs.qza \
    --o-clean-sequences silva-138.1-ssu-nr99-seqs-cleaned.qza


qiime rescript filter-seqs-length-by-taxon \
    --i-sequences silva-138.1-ssu-nr99-seqs-cleaned.qza \
    --i-taxonomy silva-138.1-ssu-nr99-tax.qza \
    --p-labels Archaea Bacteria Eukaryota \
    --p-min-lens 900 1200 1400 \
    --o-filtered-seqs silva-138.1-ssu-nr99-seqs-filt.qza \
    --o-discarded-seqs silva-138.1-ssu-nr99-seqs-discard.qza 

# dereplicate
# Here we will use the silva lowest common ancestor (But not chosen)
qiime rescript dereplicate \
    --i-sequences silva-138.1-ssu-nr99-seqs-filt.qza \
    --i-taxa silva-138.1-ssu-nr99-tax.qza \
    --p-perc-identity 0.97 \
    --p-rank-handles 'silva' \
    --p-mode 'lca' \
    --o-dereplicated-sequences silva-138.1-ssu-c97-seqs-derep-lca.qza \
    --o-dereplicated-taxa silva-138.1-ssu-c97-tax-derep-lca.qza \
    --p-threads 10

# dereplicate 
# Here we will use the default uniq approach. That is, we’ll retain identical sequence records that have differing taxonomies. 
qiime rescript dereplicate \
    --i-sequences silva-138.1-ssu-nr99-seqs-filt.qza  \
    --i-taxa silva-138.1-ssu-nr99-tax.qza \
    --p-rank-handles 'silva' \
    --p-mode 'uniq' \
    --o-dereplicated-sequences silva-138.1-ssu-nr99-seqs-derep-uniq.qza \
    --o-dereplicated-taxa silva-138.1-ssu-nr99-tax-derep-uniq.qza \
    --p-threads 10

# rename
mv silva-138.1-ssu-nr99-seqs-derep-uniq.qza silva-138-99-seqs.qza 
mv silva-138.1-ssu-nr99-tax-derep-uniq.qza silva-138-99-tax.qza


# for v3-v4 region 

qiime feature-classifier extract-reads \
--i-sequences ./silva-138-99-seqs.qza \
--p-f-primer  CCTAYGGGRBGCASCAG \
--p-r-primer GGACTACNNGGGTATCTAAT \
--p-min-length 300 \
--p-max-length 600 \
--p-n-jobs 10 \
--p-read-orientation 'forward' \
--o-reads ./silva-138-99-341F806R.qza \
--verbose



# some invalid tax should be dereplicate
# Not necessary
# qiime taxa filter-seqs --i-sequences ./silva-138-99-341F806R.qza \
#    --i-taxonomy ./silva-138-99-tax.qza \
#   --p-include  "g__Muribaculaceae" \
#    --p-mode 'contains' \
#    --o-filtered-sequences ./silva-138-99-341F806R-includeMur.qza   # exclude the sequence

#qiime rescript filter-taxa \
#    --i-taxonomy ./silva-138-99-tax.qza \
##    --p-include  "g__Muribaculaceae" \
 #   --o-filtered-taxonomy ./silva-138-99-tax-includeMur.qza 

#qiime rescript dereplicate \
#    --i-sequences ./silva-138-99-341F806R-includeMur.qza  \
#    --i-taxa ./silva-138-99-tax-includeMur.qza  \
#    --p-perc-identity 0.97 \
#    --p-rank-handles 'silva' \
##    --p-mode 'lca' \
#   --o-dereplicated-sequences ./silva-138-99-341F806R-includeMur-dera-lca.qza \
#   --o-dereplicated-taxa ./silva-138-99-tax-includeMur-dere-lca.qza  \
#   --p-threads 10

# Filter uncultured genus 




qiime taxa filter-seqs --i-sequences ./silva-138-99-341F806R.qza \
    --i-taxonomy ./silva-138-99-tax.qza \
    --p-exclude  "g__uncultured"\
    --o-filtered-sequences ./silva-138-99-341F806R-ExUncultured.qza   # exclude the sequence


qiime rescript filter-taxa \
    --i-taxonomy ./silva-138-99-tax.qza  \
    --m-ids-to-keep-file ./silva-138-99-341F806R-ExUncultured.qza  \
    --o-filtered-taxonomy ./silva-138-99-tax-ExUncultured.qza

#or use exclude
#qiime rescript filter-taxa \
#    --i-taxonomy ./silva-138-99-tax.qza  \
#    --p-exclude  "g__uncultured"\
#    --o-filtered-taxonomy ./silva-138-99-tax-ExUncultured2.qza


# dereplicate the sequence

qiime rescript dereplicate \
    --i-sequences  ./silva-138-99-341F806R-ExUncultured.qza \
    --i-taxa ./silva-138-99-tax-ExUncultured.qza \
    --p-rank-handles 'silva' \
    --p-mode 'uniq' \
    --o-dereplicated-sequences ./silva-138-99-341F806R-ExUncultured-uniq.qza \
    --o-dereplicated-taxa ./silva-138-99-tax-ExUncultured-uniq.qza

# change g__Muribaculaceae to g__unidentified

qiime rescript edit-taxonomy \
    --i-taxonomy ./silva-138-99-tax-ExUncultured-uniq.qza \
    --p-search-strings g__Muribaculaceae \
    --p-replacement-strings  g__Unidentified_Muribaculaceae \
    --o-edited-taxonomy ./silva-138-99-tax-ExUncultured-uniq-fixed.qza

# ====== produce NCBI taxa and sequence which is better than silva
# this step should be processed by hand

qiime taxa filter-seqs --i-sequences ../results/blast/ncbi-refseqs-filtered-341F806R.qza  \
    --i-taxonomy ../results/blast/ncbi-refseqs-taxonomy-filtered.qza \
    --p-include  "k__Bacteria; p__Firmicutes; c__Clostridia; o__Eubacteriales; f__Lachnospiraceae; g__Kineothrix; s__alysoides","k__Bacteria; p__Bacteroidota; c__Bacteroidia; o__Bacteroidales; f__Muribaculaceae; g__Duncaniella; s__dubosii","k__Bacteria; p__Firmicutes; c__Clostridia; o__Eubacteriales; f__Oscillospiraceae; g__Lawsonibacter; s__asaccharolyticus" \
    --o-filtered-sequences ./ncbi-341F806R-add.qza 

qiime rescript filter-taxa \
    --i-taxonomy ../results/blast/ncbi-refseqs-taxonomy-filtered.qza  \
    --m-ids-to-keep-file ./ncbi-341F806R-add.qza   \
    --o-filtered-taxonomy ./ncbi-add.qza

# ----!!!!! this use space as deliminator 
qiime rescript edit-taxonomy \
    --i-taxonomy ./ncbi-add.qza \
    --p-search-strings "k__" 's__alysoides' "s__dubosii" "s__asaccharolyticus" \
    --p-replacement-strings  "d__" 's__Kineothrix_alysoides' "s__Duncaniella_dubosii" "s__Lawsonibacter_asaccharolyticus"  \
    --o-edited-taxonomy ./ncbi-add-taxa.qza

# according to the previous result from NCBI, we update some of the tax and sequence to our own reference database

qiime feature-table merge-taxa \
    --i-data ./silva-138-99-tax-ExUncultured-uniq-fixed.qza ./ncbi-add-taxa.qza  \
    --o-merged-data silva-NCBI-mice-taxa-ver01.qza

qiime feature-table merge-seqs \
    --i-data ./silva-138-99-341F806R-ExUncultured-uniq.qza ./ncbi-341F806R-add.qza\
    --o-merged-data silva-NCBI-mice-seq-ver01.qza


