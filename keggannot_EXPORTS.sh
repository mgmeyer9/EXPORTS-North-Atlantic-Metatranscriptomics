#!/bin/bash

#SBATCH -p general
#SBATCH --nodes=1
#SBATCH --time=0-2:00:00
#SBATCH --mem=30G
#SBATCH --ntasks=1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mgmeyer9@email.unc.edu
#SBATCH -J kegannot
#SBATCH -o kegannot.%A.out
#SBATCH -e kegannot.%A.err

cd
export PYTHONPATH=/proj/marchlab/tools/keggannot:$PYTHONPATH python2
#bin/keggannot_genes2ko
/proj/marchlab/tools/keggannot/bin/keggannot_genes2ko

PATH=$PATH:/proj/marchlab/tools/keggannot/bin
PYTHONPATH=/proj/marchlab/tools/keggannot:$PYTHONPATH python2
outdir=/proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/annotation/megakegg.tsv

keggannot_genes2ko -m /nas/longleaf/data/KEGG/KEGG/ /proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/annotation/Si_m8_annotations_11_23/clustered_assembly.fastakegg_combined.m8 > /proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/annotation/cat_assemblies1_kegg.tsv
