#!/bin/bash
#SBATCH -p general
#SBATCH --nodes=1
#SBATCH --time=0-04:00:00
#SBATCH --mem=20G
#SBATCH --ntasks=1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mgmeyer9@email.unc.edu
#SBATCH -J salmon_trin
#SBATCH -o salmonexp1.%A.out
#SBATCH -e salmonexp1.%A.err

#!/bin/bash
export PATH=/nas/longleaf/apps/salmon/1.9.0/bin:$PATH
export LD_LIBRARY_PATH=/nas/longleaf/apps/salmon/1.9.0/lib:$LD_LIBRARY_PATH

indir=/proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/trimmed_reads/
outdir=/proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/alignment/

mkdir -p exp2
module add salmon

#First need to create index, then map
#salmon index -i /proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/alignment/assemblyindex \--transcripts /proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/cdhit/*.fasta -k 31
#for s in `echo $input1`; do

#samples=‘NO3-Dep-A NO3-Dep-B NO3-Dep-C NO3-Rep-B NO3-Rep-C’
samples='2-2-1A 2-2-1B 2-2-1C 2-4-1A 2-4-1B 2-4-1C 2-8-1A 2-8-1B 2-81C 2-9-1A 2-9-1B 2-9-1C 3-2-1A 3-2-1B 3-2-1C 3-5-1A 3-5-1B 3-5-1C 3-6-1A 3-6-1B 3-6-1C 3-8-1A 3-8-1B 3-8-1C'

for s in $samples; do
    echo ${s}
    R1=`ls -l $indir | grep -o ${s}_R1_001_val_1.fq.gz`
    R2=`ls -l $indir | grep -o ${s}_R2_001_val_2.fq.gz`
    echo ${R1}
    echo ${R2}
    jobfile="salmonquant${s}.sh"
    echo $jobfile
    cat <<EOF > $jobfile
#!/bin/bash
#SBATCH -N 1
#SBATCH -t 05-00:00:00
#SBATCH --mem=250g
#SBATCH -n 16
#SBATCH -o salmonexp2.%A.out
#SBATCH -e salmonexp2.%A.err

module add salmon
echo 'BEGIN'
date
hostname
salmon quant -l A -i /proj/marchlab/projects/EXPORTS/metatranscriptomics/diel_2/alignment_test/assemblyindex \
        -1 $indir/${R1} \\
        -2 $indir/${R2} \\
        -p 5 --validateMappings \\
        -o exp1_quants2/${s}_quant

echo 'END'

date

EOF

    sbatch $jobfile

done
