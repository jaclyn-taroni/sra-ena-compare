#!/bin/bash

# all the data will be held in this directory
mkdir data && cd data

# each experiment will live in it's own directory
# SRP023539
mkdir SRP023539 && cd SRP023539

# files retrieved from the European Nucleotide archive will be separate
# we can get gzipped fastq files from them without any conversion
mkdir ENA && cd ENA

# samples from SRP023539
declare -a arr=("SRR873426" "SRR873427" "SRR873428" "SRR873429" "SRR873430" "SRR873436")

for samp in "${arr[@]}"
do
  echo "Downloading sample $samp from ENA"
  # this is a paired-end experiment
  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR873/${samp}/${samp}_1.fastq.gz
  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR873/${samp}/${samp}_2.fastq.gz
done

# now get the SRA files with fasterq-dump
cd .. && mkdir SRA && cd SRA
for samp in "${arr[@]}"
do
  echo "Downloading sample $samp from SRA"
  # this is a paired-end experiment
  fasterq-dump ${samp} -e 10
done

# next experiment - SRP036035, which is single-end
cd ../.. && mkdir SRP036035 && cd SRP036035

# european nucleotide archive
mkdir ENA && cd ENA
for i in {4..9}
do
  echo "Downloading SRR114660${i} from ENA"
  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR114/00${i}/SRR114660${i}/SRR114660${i}.fastq.gz
done

# fasterq-dump
cd .. && mkdir SRA && cd SRA
declare -a arr=("SRR1146604" "SRR1146605" "SRR1146606" "SRR1146607" "SRR1146608" "SRR1146609")
for samp in "${arr[@]}"
do
  echo "Downloading sample $samp from SRA"
  # this is a paired-end experiment
  fasterq-dump ${samp} -e 10
done
