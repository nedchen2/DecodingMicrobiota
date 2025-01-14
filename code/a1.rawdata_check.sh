# based on raw data check by 'zcat', I found that the barcode ( length 6 for each read (e.g. CAAAAG in AOM.DSS.1.raw_2.fq.gz)) is in the sequence. 
# The Primer sequence is also in the data ( length 17,20 for each read (e.g. CCTAYGGGRBGCASCAG(r1),GGACTACNNGGGTATCTAAT(r2) in AOM.DSS.1.raw_2.fq.gz))). So i decided to trim the adapter 
# trim barcode along with adpator first
# 16S Primer use : primers 341F (5-CCTAYGGGRBGCASCAG-3) and 806R (5-GGACTACNNGGGTATCTAAT-3) flanking the V3 and V4 regions

# Let's try trim the adpator first 

qiime cutadapt trim-paired \
    --p-cores 4 \
    --i-demultiplexed-sequences ../results/a.raw_data/paired-end-demux.qza\
    --p-front-f CCTAYGGGRBGCASCAG \
    --p-front-r GGACTACNNGGGTATCTAAT \
    --p-error-rate 0.1 \
    --p-overlap 3 \
    --p-match-read-wildcards \
    --p-match-adapter-wildcards \
    --p-discard-untrimmed \
    --o-trimmed-sequences ../results/a.raw_data/Primer_trimmed-seqs.qza

# make a report to judge the base length to trim
qiime demux summarize --i-data ../results/a.raw_data/Primer_trimmed-seqs.qza --o-visualization ../results/a.raw_data/Primer_trimmed-seqs.qzv

# visualize the quality report
qiime tools view ../results/a.raw_data/Primer_trimmed-seqs.qzv

