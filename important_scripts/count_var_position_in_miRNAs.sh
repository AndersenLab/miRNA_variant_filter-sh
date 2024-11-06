#!/bin/bash

# Define directories
base_dir="/vast/eande106/projects/Tabor/smRNA_variants"
proc_fold="${base_dir}/processed_data/"
raw_fold="${base_dir}/raw_data/"

# Define input and output files
vcf_file="${proc_fold}WI.20231213.hard-filter.isotype_no_hdr-rr_miRNA-genes.vcf.gz"
bed_file="${raw_fold}cgnc_miRNA_12345xMt_all_info.bed"
output_bed="${proc_fold}cgnc_vars_all_info.bed"

# Prepare the output file with a header (optional, if needed)
echo -e "chromosome\tstart\tend\tname\tother_info\tstrand\trelative_position" > "$output_bed"

# Process each line of the VCF file
zcat "$vcf_file" | while read -r vcf_line; do
    # Read chromosome and position from VCF line
    vcf_chrom=$(echo "$vcf_line" | awk '{print $1}')
    vcf_pos=$(echo "$vcf_line" | awk '{print $2}')
    
    # Search in BED file for matching chromosome and region containing VCF position
    awk -v chrom="$vcf_chrom" -v pos="$vcf_pos" \
    'BEGIN {OFS="\t"} 
    $1 == chrom && pos >= $2 && pos <= $3 {
        # Determine relative position based on strand orientation
        if ($6 == "-") {
            relative_position = $3 - pos + 1  # Count from the end for antisense strand
        } else {
            relative_position = pos - $2 + 1  # Count from start for sense strand
        }
        # Print to output file
        print $1, $2, $3, $4, $5, $6, relative_position
    }' "$bed_file" >> "$output_bed"
done
