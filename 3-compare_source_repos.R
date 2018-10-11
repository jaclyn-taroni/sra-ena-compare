# J. Taroni for ALSF CCDL 2018 
# Command line usage: Rscript compare_source_repos.R

compare_source_repo_quant <- function(sra_file, ena_file) {
  # given the full paths to an SRA and ENA tximport TSV output, calculate the
  # Spearman correlation between the source repository outputs for the *same*
  # sample
  # read in the tximport results from each source repository
  sra_df <- readr::read_tsv(sra_file)
  ena_df <- readr::read_tsv(ena_file)
  # get sample identifiers from the SRA data.frame -- gene ids are in the
  # first column
  samples <- colnames(sra_df)[2:ncol(sra_df)]
  # calculate the correlation between the outputs from each source repository
  cor_vector <- c()
  for (smpl in samples) {
    cor_vector <- append(cor_vector, cor(sra_df[[smpl]], ena_df[[smpl]], 
                                         method = "spearman"))
  }
  return(cor_vector)
}

# single end experiment
single_correlations <- 
  compare_source_repo_quant(sra_file = file.path("gene_level", 
                                                 "SRP036035_SRA.tsv"),
                            ena_file = file.path("gene_level", 
                                                 "SRP036035_ENA.tsv"))

# paired end experiment
paired_correlations <- 
  compare_source_repo_quant(sra_file = file.path("gene_level", 
                                                 "SRP023539_SRA.tsv"),
                            ena_file = file.path("gene_level", 
                                                 "SRP023539_ENA.tsv"))

# get into data.frame that is amenable to plotting
correlation_df <- 
  data.frame(rbind(cbind(single_correlations, 
                         rep("SRP036035", length(single_correlations))),
                   cbind(paired_correlations, 
                         rep("SRP023539", length(paired_correlations)))))
colnames(correlation_df) <- c("correlation", "experiment")
correlation_df$correlation <- as.numeric(as.character(correlation_df$correlation))

# make plot and save as png
ggplot2::ggplot(correlation_df, 
                ggplot2::aes(x = experiment, y = correlation)) +
  ggplot2::geom_boxplot() +
  ggplot2::geom_jitter() +
  ggplot2::ylim(c(0, 1)) +
  ggplot2::theme_bw() +
  ggplot2::theme(axis.text.x = ggplot2::element_text(hjust = 1, angle = 45),
                 plot.title = ggplot2::element_text(hjust = 0.5, 
                                                    face = "bold")) +
  ggplot2::ggtitle("ENA FTP vs. SRA fasterq-dump")
ggplot2::ggsave("correlation_plot.png")
