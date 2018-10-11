# J. Taroni 2018
# Summarize Salmon quant results to the gene-level with tximport. Specifically,
# to lengthScaledTPM output. The (human) gene to transcript mapping is 
# hardcoded for this project/repo.
# 
# Args:
#   --quant_dir: the directory that contains the quant files
#   --txi_out: the filename of the tximport output, including the full path
#
# Command line usage:
#   Rscript tximport.R --quant_dir <QUANT_DIRECTORY> --txi_out <TPM_TSV_FILE>
# 

# set up command line arguments ------------------------------------------------

option_list <- list(
  optparse::make_option("--quant_dir", type = "character"),
  optparse::make_option("--txi_out", type = "character")
)

opt_parser <- optparse::OptionParser(option_list = option_list)
opt <- optparse::parse_args(opt_parser)

quant_dir <- opt$quant_dir
txi_out <- opt$txi_out

# main -------------------------------------------------------------------------

# identify the quant.sf files in the user specified directory, with the full
# path
sf_files <- list.files(quant_dir, recursive = TRUE, full.names = TRUE,
                       pattern = "quant.sf")

# we need to get the sample names to name the file vector, otherwise we'll end
# up with no sample names in the TSV output and can't do downstream analysis!
sample_names <- stringr::word(sf_files, -2, sep = "/")
names(sf_files) <- sample_names

# this is the path to the file that contains the tx to gene mapping req'd for
# tximport
gene2txmap <- file.path("data", "hsapiens_tx2gene.tsv")

# if it doesn't exist yet, make that file from the human GTF file
# essentially this will happen the first time this gets run
if(!file.exists(gene2txmap)) {
  # derive transcript to gene mapping from gtf
  ensembldb::ensDbFromGtf(file.path("data", "Homo_sapiens.GRCh38.94.gtf"),
                          outfile = file.path("data",
                                              "Homo_sapiens.GRCh38.94.sqlite"))
  edb <- ensembldb::EnsDb(file.path("data",
                                    "Homo_sapiens.GRCh38.94.sqlite"))
  tx <- ensembldb::transcriptsBy(edb, by = "gene")
  tx.df <- as.data.frame(tx@unlistData)
  tx2gene <- tx.df[, c("tx_name", "gene_id")]
  readr::write_tsv(tx2gene, file.path("data", "hsapiens_tx2gene.tsv"))
} else {
  # if it does exist, just read it in
  tx2gene <- readr::read_tsv(gene2txmap)
}

# tximport main function and writing the data.frame to file specified by 
# txi_out argument
txi_length_scaled <- tximport::tximport(files = sf_files,
                                        type = "salmon",
                                        tx2gene = tx2gene,
                                        countsFromAbundance = "lengthScaledTPM",
                                        ignoreTxVersion = TRUE)
lstpm_df <- as.data.frame(txi_length_scaled$counts)
lstpm_df <- tibble::rownames_to_column(lstpm_df, var = "Gene")
readr::write_tsv(lstpm_df, path = txi_out)
