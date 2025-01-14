#mkdir for the feature table
mkdir ../results/b.feature_table/

# as our primer is # 16S Primer use : primers 341F (5-CCTAYGGGRBGCASCAG-3) length 17 and 806R (5-GGACTACNNGGGTATCTAAT-3) length 20 flanking the V3 and V4 regions
# bascially, the length "--p-trunc-len-f"  would be accurate 

# ====== denoise the sequence into feature table
qiime dada2 denoise-paired \
    --i-demultiplexed-seqs ../results/a.raw_data/Primer_trimmed-seqs.qza \
    --p-trunc-len-f 227 \
    --p-trunc-len-r 224 \
    --p-trim-left-f 0 \
    --p-trim-left-r 0 \
    --p-n-threads 4 \
    --o-representative-sequences  ../results/b.feature_table/rep-seqs.qza \
    --o-table ../results/b.feature_table/table.qza \
    --o-denoising-stats ../results/b.feature_table/denoising-stats.qza


# ====== ALternative: Try not doing any trimming process (i.e, the cutadapt) before dada2 =========
# These method is identical to the method above. Just As an alternative to. If you have run the previous one, do not run these again.

qiime dada2 denoise-paired \
    --i-demultiplexed-seqs ../results/a.raw_data/paired-end-demux.qza \
    --p-trunc-len-f 250 \
    --p-trunc-len-r 250 \
    --p-trim-left-f 23 \
    --p-trim-left-r 26 \
    --p-n-threads 4 \
    --o-representative-sequences  ../results/b.feature_table/rep-seqs.qza \
    --o-table ../results/b.feature_table/table.qza \
    --o-denoising-stats ../results/b.feature_table/denoising-stats.qza


