#!/bin/bash
#SBATCH -N 1
#SBATCH -t 05-00:00:00
#SBATCH --mem=250g
#SBATCH -n 16
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mgmeyer9@email.unc.edu
#SBATCH -o salmonexp1.%A.out
#SBATCH -e salmonexp1.%A.err

module add salmon
echo 'BEGIN'
date
hostname
salmon quant -l A -i /proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/alignment/assemblyindex         -1 /proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/trimmed_reads//Diel-2-9_R1_001_val_1.fq.gz \
        -2 /proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/trimmed_reads//Diel-2-9_R2_001_val_2.fq.gz \
        -p 5 --validateMappings \
        -o exp1_quants/Diel-2-9_quant

echo 'END'

date
