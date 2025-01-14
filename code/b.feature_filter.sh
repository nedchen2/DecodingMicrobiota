# we may filter out the sequence which only appear in one sample
# 10% pervalence filter

qiime feature-table filter-features \
  --i-table ../results/b.feature_table/table.qza \
  --p-min-samples 2 \
  --o-filtered-table ../results/b.feature_table/sample-contingency-filtered-table.qza

# we may also filter out the sequence which only have sum of abundance lower than 10. could be induced by sequencing error

qiime feature-table filter-features \
  --i-table ../results/b.feature_table/sample-contingency-filtered-table.qza \
  --p-min-frequency 10 \
  --o-filtered-table ../results/b.feature_table/filtered-table.qza

# filter sequence 

qiime feature-table filter-seqs \
  --i-data  ../results/b.feature_table/rep-seqs.qza \
  --i-table ../results/b.feature_table/filtered-table.qza \
  --o-filtered-data ../results/b.feature_table/filtered-rep-seqs.qza

# filtered seq and table file  filtered-table.qza/filtered-rep-seqs.qza
# visualize and stat the reult

qiime  feature-table summarize \
  --i-table  ../results/b.feature_table/filtered-table.qza  \
  --o-visualization  ../results/b.feature_table/filtered-table.qzv \
  --m-sample-metadata-file  ./sample-metadata.tsv

# We may check the sequence and table

qiime feature-table tabulate-seqs \
  --i-data  ../results/b.feature_table/filtered-rep-seqs.qza \
  --o-visualization  ../results/b.feature_table/filtered-rep-seqs.qzv
