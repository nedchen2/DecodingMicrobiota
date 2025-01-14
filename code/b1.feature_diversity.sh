# mkdir for alpha diversity

mkdir ../results/c.diversity_ana

# as the sampling effect will influence the total size of the library for each sample. We need to decide which library size to retain
# try "--p-max-depth" 50000,30000,10000,5000

qiime diversity alpha-rarefaction \
  --i-table ../results/b.feature_table/filtered-table.qza  \
  --p-max-depth 50000 \
  --p-min-depth 10 \
  --m-metadata-file ./sample-metadata.tsv \
  --o-visualization ../results/c.diversity_ana/alpha-rarefaction.qzv

# construct phylogenetic tree

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences ../results/b.feature_table/filtered-rep-seqs.qza \
  --o-alignment  ../results/c.diversity_ana/aligned-rep-seqs.qza \
  --o-masked-alignment  ../results/c.diversity_ana/masked-aligned-rep-seqs.qza \
  --o-tree  ../results/c.diversity_ana/unrooted-tree.qza \
  --o-rooted-tree  ../results/c.diversity_ana/rooted-tree.qza


# --p-sampling-depth decided from filtered-table.qzv and alpha-rarfaction plot
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../results/c.diversity_ana/rooted-tree.qza \
  --i-table ../results/b.feature_table/filtered-table.qza \
  --p-sampling-depth 50000\
  --m-metadata-file ./sample-metadata.tsv \
  --output-dir ../results/c.diversity_ana/core-metrics-results

# plus chao1
qiime diversity alpha \
  --i-table ../results/b.feature_table/filtered-table.qza  \
  --p-metric chao1 \
  --o-alpha-diversity ../results/c.diversity_ana/core-metrics-results/chao1_vector.qza

# compare alpha diversity with metadata

qiime diversity alpha-group-significance \
  --i-alpha-diversity ../results/c.diversity_ana/core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file ./sample-metadata.tsv \
  --o-visualization ../results/c.diversity_ana/core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity ../results/c.diversity_ana/core-metrics-results/shannon_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization ../results/c.diversity_ana/core-metrics-results/shannon-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity ../results/c.diversity_ana/core-metrics-results/evenness_vector.qza \
  --m-metadata-file ./sample-metadata.tsv \
  --o-visualization ../results/c.diversity_ana/core-metrics-results/evenness-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity ../results/c.diversity_ana/core-metrics-results/observed_features_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization ../results/c.diversity_ana/core-metrics-results/observed_features_vector-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity ../results/c.diversity_ana/core-metrics-results/chao1_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization ../results/c.diversity_ana/core-metrics-results/chao1-group-significance.qzv



# compare beta diversity with metadata 
qiime diversity beta-group-significance \
    --i-distance-matrix ../results/c.diversity_ana/core-metrics-results/weighted_unifrac_distance_matrix.qza \
    --m-metadata-file ./sample-metadata.tsv \
    --m-metadata-column Group \
    --o-visualization ../results/c.diversity_ana/core-metrics-results/weighted_unifrac_distance_matrix-Group-significance.qzv \
    --p-pairwise 


qiime diversity beta-group-significance \
  --i-distance-matrix ../results/c.diversity_ana/core-metrics-results/bray_curtis_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column Group \
  --o-visualization ../results/c.diversity_ana/core-metrics-results/bray_curtis_distance_matrix-group-significance.qzv \
  --p-pairwise
