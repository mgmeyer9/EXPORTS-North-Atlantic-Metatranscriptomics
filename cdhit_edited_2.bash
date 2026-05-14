#!/bin/bash
#SBATCH -p general
#SBATCH -N 1
#SBATCH -t 3-00:00:00
#SBATCH -J cdhit_trinity
#SBATCH -o cdhit_trinity.%j.out
#SBATCH -e cdhit_trinity.%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mgmeyer9@email.unc.edu
#SBATCH --mem=300G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1

indir=/proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/assembly/
outdir=/pine/scr/m/g/mgmeyer9/cdhit/
module load cdhit
#During assembly contigs are assigned Trinity IDs, these are unique within each assembly but not between assemblies. Combining assemblies into grand assembly
#without renaming causes issues downstream

cat<<EOF>create_py_env.bash
python3 -m venv bioinfo
source bioinfo/bin/activate
pip install --upgrade pip
pip install Bio
EOF

sh ${SLURM_SUBMIT_DIR}/create_py_env.bash

# appends sample number (or name) to the id of each contig in assembly file (simple fasta format)
# run after successful completion of all assemblies

samples=`ls ${dir}*.Trinity.fasta | awk -F '_trinity' '{print $1}'`

# activate the python environment where Bio.SeqIO Module installed
venv="${SLURM_SUBMIT_DIR}/bioinfo"
source ${venv}/bin/activate

echo "Append sample name or number to each seq id within fasta assembly ..."
for s in `echo ${samples}`; do
    echo " ... ${s}"
	cat
    infile="${s}*.Trinity.fasta"
    outfile="${s}_trinity_renamed.fasta"
	a=`basename ${s}`
    python /proj/marchlab/tools/rename_fasta_id.py ${infile} ${outfile} ${a}
done

#run cdhit

#this should be improved to allow easy unique user input. Determining which samples should be combined requires knowing the design setup, use a metadata file??
#for now .. list of files in assemblies 1 - n
assemblies="1"
cd /proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/assembly/
echo "Concatenate assemblies and cluster using cd-hit-est..."
for i in `echo $assemblies`; do
if [ ! -d ${outdir}assembly_${i}_files_to_cat ]
then
    mkdir -p ${outdir}assembly_${i}_files_to_cat
fi
rsync `ls ${dir}*-${i}*renamed*` ${outdir}assembly_${i}_files_to_cat
if [ ! -f ${outdir}assembly_${i}.fasta ]
then
	echo "concatenate files for assembly ${i}"
	cat ls  ${outdir}assembly_${i}_files_to_cat/* > ${outdir}cat_assemblies${i}.fasta
fi
echo "cd-hit-est for assembly ${i}"
cd-hit-est \
 -i cat_assemblies${i}.fasta \
 -o clustered_assembly${i}.fasta \
 -c .98 -n 10 -d 100 \
 -T ${SLURM_CPUS_PER_TASK} \
 -M 40000
done
