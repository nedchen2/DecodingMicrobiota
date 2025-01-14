# import the data into qiime 2
qiime tools import   --type 'SampleData[PairedEndSequencesWithQuality]'   --input-path manifest.tsv   --output-path ../results/a.raw_data/paired-end-demux.qza   --input-format PairedEndFastqManifestPhred33V2
