#!/bin/bash
#SBATCH -J J01_miR_vcf                  # Job name
#SBATCH -A eande106                     # Allocation name
#SBATCH -p parallel                     # Partition/Queue name
#SBATCH -t 01:00:00                     # Job walltime/duration (hh:mm:ss)
#SBATCH -N 1                            # Number of nodes
#SBATCH -n 12                           # Number of cores
#SBATCH --mail-user=troderi2@jh.edu     # Email for job notifications
#SBATCH --mail-type=END                 # Notify when job ends
#SBATCH --output=/home/troderi2/vast-eande106/projects/Tabor/smRNA_variants/processed_data/slurm_output/output_J01.txt
#SBATCH --error=/home/troderi2/vast-eande106/projects/Tabor/smRNA_variants/processed_data/slurm_output/error_J01.txt

module load anaconda

conda activate discovar

./count_var_position_in_miRNAs.sh

./count_var_position_in_3pUTR_binding_sites.sh
