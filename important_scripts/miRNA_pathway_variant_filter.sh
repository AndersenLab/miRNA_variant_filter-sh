#!/bin/bash

# this code will create three VCFs
# one without HDRs and RRs, albeit incorrectly (see note below)
# two with either the microRNA gene variants or their 3'UTR predicted binding site variants

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# this code is not isotype-HDR specific, regions of HDRs from one isotype #
# were removed in all isotypes whether or not that region had those HDRs  #
# additionally hard.filter isotype was not filtered to only include       #
# bi-allelic SNVs                                                         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Step 1
START_TIME=$(date +%s)
echo "Script started at: $(date)"
echo
# folders and files
base_dir="/vast/eande106/projects/Tabor/smRNA_variants"
out_fold="$base_dir/processed_data/"
raw_fold="$base_dir/raw_data/"
temp_fold="$base_dir/temp_data/" 
vcf="${raw_fold}WI.20231213.hard-filter.isotype.vcf.gz"
hdr_gz="${raw_fold}20231213_c_elegans_divergent_regions_all.bed.gz" # HDRs
rr="${raw_fold}rr_12345xMt.bed" # repetitive regions wormbase jbrowser
# Concatenating HDR and RR 
zcat "$hdr_gz" > "${temp_fold}20231213_c_elegans_divergent_regions_all.bed"
hdr="${temp_fold}20231213_c_elegans_divergent_regions_all.bed"
cat "$hdr" "$rr" > "${temp_fold}cat_hdr_rr.bed"
cat_hdrr="${temp_fold}cat_hdr_rr.bed"
# prune out HDR and RR from VCF
STARThdrr_TIME=$(date +%s)
zcat "$vcf" | bedtools intersect -v -a stdin -b "$cat_hdrr" | bgzip -c >> "${out_fold}WI.20231213.hard-filter.isotype_no_hdr-rr.vcf.gz"
ENDhdrr_TIME=$(date +%s)
ELAPSEDhdrr_TIME=$((ENDhdrr_TIME - STARThdrr_TIME))
echo "Elapsed HDR and RR Filtering Time: $ELAPSEDhdrr_TIME seconds"

# Step 2A
STARTmiRNAfunc_TIME=$(date +%s)
new_vcf="${out_fold}WI.20231213.hard-filter.isotype_no_hdr-rr.vcf.gz"
# bedtools will not work on a VCF file unless it has at least one ##header line 
(zcat "$vcf" | head -n 1 && zcat "$new_vcf") | bgzip -c > "${new_vcf}.tmp" && mv "${new_vcf}.tmp" "$new_vcf"
# filter retaining microRNAs
zcat "$new_vcf" | bedtools intersect -a stdin -b "${raw_fold}cgnc_miRNA_12345xMt.bed" | bgzip -c > "${out_fold}WI.20231213.hard-filter.isotype_no_hdr-rr_miRNA-genes.vcf.gz"

# Step 2B
zcat "$new_vcf" | bedtools intersect -a stdin -b "${raw_fold}mipbs_12345xMt.bed" | bgzip -c > "${out_fold}WI.20231213.hard-filter.isotype_no_hdr-rr_miRNA-3pUTR-targetsites.vcf.gz"
ENDmiRNAfunc_TIME=$(date +%s)
ELAPSEDmiRNAfunc_TIME=$((ENDmiRNAfunc_TIME - STARTmiRNAfunc_TIME))
echo "Elapsed miRNA gene and their 3pUTR target site Filtering Time: $ELAPSEDmiRNAfunc_TIME seconds"

# remove temp files
rm "${temp_fold}cat_hdr_rr.bed" "${temp_fold}20231213_c_elegans_divergent_regions_all.bed"

# end script
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
echo "Script Total Elapsed Time: $ELAPSED_TIME seconds"
echo "Script ended at: $(data). Goodbye."
