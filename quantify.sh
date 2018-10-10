#!/bin/bash

mkdir quant && cd quant
mkdir SRP036035 && cd SRP036035
mkdir SRA && mkdir ENA

cd ../..

declare -a dir_arr=("ENA" "SRA")
declare -a arr=("SRR1146604" "SRR1146605" "SRR1146606" "SRR1146607" "SRR1146608" "SRR1146609")

for samp in "${arr[@]}"
do
  for dir in "${dir_arr[@]}"
  do
  	input_directory="data/SRP036035/${dir}"
  	fastq="${input_directory}/${samp}.fastq"
  	output_directory="quant/SRP036035/${dir}/${samp}"
  if [ $dir == "ENA" ]
  	then
  	  fastq="${fastq}.gz"
	fi
	salmon --no-version-check quant -l A -i transcriptome_index/hsapiens_short \
	  -r $fastq -p 16 -o $output_directory \
	  --seqBias --dumpEq --writeUnmappedNames
  done
done
