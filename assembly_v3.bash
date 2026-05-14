#!/bin/bash
#SBATCH -N 1
#SBATCH -t 6-00:00:00
#SBATCH -J trinity
#SBATCH -o trinity.%j_%a.out
#SBATCH -e trinity.%j_%a.err
#SBATCH --array=7-9%3
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mgmeyer9@email.unc.edu
#SBATCH --mem=500G
#SBATCH --cpus-per-task=5
#SBATCH --ntasks=1


module load trinity
cd /pine/scr/m/g/mgmeyer9
#set in directory to where trimmed reads are stored
indir=/proj/marchlab/projects/EXPORTS/metatranscriptomics/NorthAltantic/trimmed_reads
RUN=${SLURM_ARRAY_TASK_ID}
input=`ls ${indir}/*R1*gz | awk -F 'R1' '{print $1}'| sed -n ${RUN}p`
a=`basename ${input}`
#make unique out directory for each sample by amending sample name to trinity outdir !!out directory must contain 'trinity'!!
outdir=/pine/scr/m/g/mgmeyer9/NorthAltantic/assembly/${a}trinity
#hpc_cmds_GridRunner.pl is stored here
griddir=/proj/marchlab/tools/HpcGridRunner

echo "Checking if ${outdir} exists ..."
if [ ! -d ${outdir} ]
then
    echo "Create directory ... ${outdir}"
    mkdir -p ${outdir}
else
    echo " ... exists"
fi

 echo "Checking completion ..."
if [ ! -f ${outdir}.Trinity.fasta ]
then
Trinity \
	--seqType fq \
	--max_memory 500G \
	--left ${input}R1*gz \
	--right ${input}R2*gz \
	--CPU ${SLURM_CPUS_PER_TASK} \
	--NO_SEQTK \
	--output ${outdir}
	/nas/longleaf/apps/trinity/2.8.6/trinityrnaseq-2.8.6/util/TrinityStats.pl ${outdir}/Trinity.fasta
fi

 echo "Checking completion ..."
if [ ! -f ${outdir}.Trinity.fasta ]
then

cat<<EOF>${a}trinity_rerun.bash
#!/bin/bash
#SBATCH -N 1
#SBATCH -t 2-00:00:00
#SBATCH -J {a}trinity_
#SBATCH -o {a}trinity_.%j.out
#SBATCH -e {a}trinity_.%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1

Trinity \
	--seqType fq \
	--max_memory 100G \
	--left ${input}R1*gz \
	--right ${input}R2*gz \
	--CPU ${SLURM_CPUS_PER_TASK} \
	--full_cleanup \
	--NO_SEQTK \
	--output ${outdir}
	/nas/longleaf/apps/trinity/2.8.6/trinityrnaseq-2.8.6/util/TrinityStats.pl ${outdir}/Trinity.fasta

echo "Checking completion ..."
if [ ! -f ${outdir}.Trinity.fasta ]
then
#sbatch ${a}trinity_rerun.bash
else
    echo " ${outdir}.Trinity.fasta complete... Delete Trinity directory."
	/nas/longleaf/apps/trinity/2.8.6/trinityrnaseq-2.8.6/util/TrinityStats.pl ${outdir}/Trinity.fasta
  rm -r ${outdir}
fi


EOF
fi
