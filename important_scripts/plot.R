# Dry lab project microRNA variants in VCF file 
# rotation 1 - Andersen
# Mentor - Lance O'Connor
# 2024 October-November
# Tabor Roderiques

# Set working direction and get data
setwd("/home/troderi2/vast-eande106/projects/Tabor/smRNA_variants/")
today <- format(Sys.Date(), "%Y%m%d")

# script path
# /home/troderi2/vast-eande106/projects/Tabor/


# # # # # # # # #
### Load Data ###
# # # # # # # # #

# Libraries
library(tidyverse)
library(dplyr)
library(ggplot2)
library(glue)


raw <- file.path(getwd(), "raw_data/")
figs <- file.path(getwd(), "plots/")



# Read the files
region_ln_cgnc <- read.table(paste0(raw, "region_ln_cgnc.txt"), header = FALSE)
region_ln_mipbs <- read.table(paste0(raw, "region_ln_mipbs.txt"), header = FALSE)

# Rename the column for clarity
colnames(region_ln_cgnc) <- "length"
colnames(region_ln_mipbs) <- "length"

# Create histogram for regions_ln_cgnc
gp1 <- ggplot(region_ln_cgnc, aes(x = length)) +
  geom_histogram(binwidth = 1, color = "black", fill = "white") +
  labs(title = "Reference Genome microRNA Lengths", x = "Length", y = "Frequency")

# Create histogram for regions_ln_mipbs
gp2 <- ggplot(region_ln_mipbs, aes(x = length)) +
  geom_histogram(binwidth = 1, color = "black", fill = "white") +
  labs(title = "Reference Genome 3'UTR Predicted Binding Site Lengths", x = "Length", y = "Frequency")
gp2

# Saving plot 1
ggsave(
  filename = glue::glue("{figs}/{today}_refG_miGenes.png"),
  plot = gp1,
  width = 10,
  height = 10,
  units = "in",
  dpi = 300
)

# Saving plot 2
ggsave(
  filename = glue::glue("{figs}/{today}_refG_3pUTRPBS.png"),
  plot = gp2,
  width = 10,
  height = 10,
  units = "in",
  dpi = 300
)
