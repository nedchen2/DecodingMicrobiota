# Train the classifier and do classification
# ========= in cloud if the memory of your laptop is not enough

qiime feature-classifier fit-classifier-naive-bayes \
    --i-reference-reads /home/silva-138-99-341F806R-ExUncultured-uniq.qza \
    --i-reference-taxonomy /home/silva-138-99-tax-ExUncultured-uniq.qza \
    --o-classifier /home/silva-138-99-341F806R-ExUncultured-classifier.qza  

qiime feature-classifier classify-sklearn \
  --i-classifier /home//silva-138-99-341F806R-ExUncultured-classifier.qza
  --i-reads /home/filtered-rep-seqs.qza \
  --o-classification /home/taxonomy.qza \
  --p-n-jobs 20


# visualize the barplot of taxonomy distribution
# ================ Check the blank sample here

qiime taxa barplot 
   --i-table ../results/b.feature_table/filtered-table.qza \
   --i-taxonomy ../results/d.taxonomy_assignment/taxonomy.qza \
   --m-metadata-file ./sample-metadata.tsv \
   --o-visualization ../results/d.taxonomy_assignment/taxa-bar-plots.qzv
# taxa-bar-plots.qzv: the counts of taxa in different level
# could use the data in it for example the level-2.csv to visualize

qiime tools export 
      --input-path ../results/d.taxonomy_assignment/taxa-bar-plots.qzv \
      --output-path ../results/d.taxonomy_assignment/Taxonomy_export 

qiime rescript edit-taxonomy \
    --i-taxonomy ../results/d.taxonomy_assignment/taxonomy.qza \
    --p-search-strings "d__" \
    --p-replacement-strings  "k__" \
    --o-edited-taxonomy ../results/d.taxonomy_assignment/taxonomy.qza
