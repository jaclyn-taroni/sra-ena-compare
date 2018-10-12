# Compare transcript estimates: ENA `fastq.gz` and SRA `fasterq-dump`

From [AlexsLemonade/refinebio#706](https://github.com/AlexsLemonade/refinebio/issues/706):

> `fastq-dump` (`fasterq-dump` predecessor) does read filtering (see [ncbi/sra-tools#159 (comment)](https://github.com/ncbi/sra-tools/issues/159#issuecomment-427269308)) which filters out reads that are all Ns ([ref](https://edwards.sdsu.edu/research/fastq-dump/)).  We assumed that this, and other features of `fasterq-dump`, do not affect our results at the transcript quantification step (e.g., `salmon quant`).

In this repository, we compare the results from `.fastq.gz` files obtained from [European Nucleotide Archive](https://www.ebi.ac.uk/ena) via FTP and `.fastq` files obtained from [NCBI Sequence Read Archive](https://www.ncbi.nlm.nih.gov/sra) with [`fasterq-dump`](https://github.com/ncbi/sra-tools/wiki/HowTo:-fasterq-dump).

We select one single-end and one paired-end (human) experiment, [`SRP036035`](https://trace.ncbi.nlm.nih.gov/Traces/sra/?study=SRP036035) and [`SRP023539`](https://trace.ncbi.nlm.nih.gov/Traces/sra/?study=SRP023539) respectively, to test this comparison.

As in refine.bio, we use the [Salmon](https://combine-lab.github.io/salmon/) `v0.9.1` and [tximport](https://bioconductor.org/packages/tximport/) `v1.6.0`. Scripts are named according to the order in which they should be run.

### Methods notes

* As mentioned above,`.fastq.gz` files were obtained from ENA via FTP and `.fastq` files obtained from NCBI Sequence Read Archive with `fasterq-dump` (`0-data_download.sh`).
* We built Salmon transcriptome indices using human `GRCh38` cDNA FASTA from Ensembl (version 94) (`1-build_txome_index.sh`). This is a little bit different from what is done in refine.bio.
* We quantified transcripts with `salmon quant`, same parameters as refine.bio (`2-quantify.sh`).
* We summarized the transcript-level estimates to the gene-level with `tximport`, same parameters as refine.bio (`tximport.R`, run with `2-quantify.sh`).
* We use Spearman correlation to measure agreement between results derived from the two source repositories (`3-compare_source_repos.R`).

### Results

![correlation](https://github.com/jaclyn-taroni/sra-ena-compare/blob/master/correlation_plot.png)

The results are highly correlated.