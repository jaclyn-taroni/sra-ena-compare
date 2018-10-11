#!/bin/bash

mkdir quant && cd quant

# first do the single-end experiment
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

now the paired-end experiment
cd quant && mkdir SRP023539 && cd SRP023539
mkdir SRA && mkdir ENA

cd ../..

declare -a dir_arr=("ENA" "SRA")
declare -a arr=("SRR873426" "SRR873427" "SRR873428" "SRR873429" "SRR873430")

for samp in "${arr[@]}"
do
  for dir in "${dir_arr[@]}"
  do
  	input_directory="data/SRP023539/${dir}"
  	fastq_1="${input_directory}/${samp}_1.fastq"
    fastq_2="${input_directory}/${samp}_2.fastq"
  	output_directory="quant/SRP023539/${dir}/${samp}"
  if [ $dir == "ENA" ]
  	then
  	  fastq_1="${fastq_1}.gz"
      fastq_2="${fastq_2}.gz"
	fi
	salmon --no-version-check quant -l A -i transcriptome_index/hsapiens_long \
	  -1 $fastq_1 -2 $fastq_2 -p 12 -o $output_directory \
	  --seqBias --dumpEq --writeUnmappedNames --biasSpeedSamp 5
  done
done
