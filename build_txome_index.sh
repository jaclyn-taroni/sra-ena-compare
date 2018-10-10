#!/bin/bash

mkdir transcriptome_index

# k = 31 is suitable for reads >=75bp
salmon index \
  -t data/Homo_sapiens.GRCh38.cdna.all.fa.gz \
  -i transcriptome_index/hsapiens_long \
  --type quasi -k 31

# k = 23 is suitable for reads < 75bp
salmon index \
  -t data/Homo_sapiens.GRCh38.cdna.all.fa.gz \
  -i transcriptome_index/hsapiens_short \
  --type quasi -k 23
 