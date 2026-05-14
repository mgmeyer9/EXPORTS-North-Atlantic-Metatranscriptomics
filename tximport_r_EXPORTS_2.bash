#!/bin/bash
#SBATCH -p general
#SBATCH --nodes=1
#SBATCH --time=0-03:00:00
#SBATCH --mem=300G
#SBATCH --ntasks=3
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=speciale@unc.edu
#SBATCH -J tximport
#SBATCH -o tximport.%A.out
#SBATCH -e tximport.%A.err

module load r/4.0.1
cd /work/users/m/g/mgmeyer9
outdir=/proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/tximport/

echo "Checking if ${outdir} exists ..."
if [ ! -d ${outdir} ]
then
    echo "Create directory ... ${outdir}"
    mkdir -p ${outdir}
else
    echo " ... exists"
fi



Rscript tximport_EXPORTS_taxa.r
