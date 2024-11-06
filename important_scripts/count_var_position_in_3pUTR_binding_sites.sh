#!/bin/bash

# Define directories
base_dir="/vast/eande106/projects/Tabor/smRNA_variants"
proc_fold="${base_dir}/processed_data" # VCF file is here
raw_fold="${base_dir}/raw_data"        # BED file is here

# Input files
vcf_file="${proc_fold}/WI.20231213.hard-filter.isotype_no_hdr-rr_miRNA-3pUTR-targetsites.vcf.gz"
bed_file="${raw_fold}/mipbs_12345xMt_all_info.bed"

# Output file
output_file="${proc_fold}/mipbs_vars_all_info.bed"

# Ensure the output file is empty at the start
> "$output_file"

# Process each line in the VCF file
zcat "$vcf_file" | while read -r vcf_line; do
    # Skip headers in VCF
    [[ "$vcf_line" =~ ^# ]] && continue

    # Extract chromosome and position from the VCF line (assuming 1st and 2nd columns)
    vcf_chr=$(echo "$vcf_line" | cut -f1)
    vcf_pos=$(echo "$vcf_line" | cut -f2)

    # Search the BED file for matching chromosome and position within each range
    awk -v chr="$vcf_chr" -v pos="$vcf_pos" -v OFS="\t" '
    $1 == chr && pos >= $2 && pos <= $3 {
        # Calculate the relative position for the `+` strand, starting from the start of the region
        relative_position = pos - $2 + 1
        
        # Print BED line with an additional column for the relative position
        print $0, relative_position
    }' "$bed_file" >> "$output_file"
done
