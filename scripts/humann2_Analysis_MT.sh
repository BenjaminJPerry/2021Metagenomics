#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --account=def-camerand
#SBATCH --job-name=humann2_MT
#SBATCH --mail-user=benjamin.perry@postgrad.otago.ac.nz
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --mem=256000M

##SBATCH --ntasks=32
##SBATCH --nodes=1

### Compute Canada Cedar Shell Script ###
# Analyzing MT/MG datasets using Humann2 Functional Profiler
# Skips Nucleotide Search
# Uses Diamond for Protein Search of UniRef50 Protein Database

### Setup the Environment ###
module load nixpkgs/16.09 miniconda3/4.3.27 fastqc/0.11.5
source activate humann2

THREADS=32
MEM=256
DATADIR=trimMT
DATA="$PROJECT"/benjijp/"$DATADIR"
WORKINGDIR="$SCRATCH"/humann2_MT_Analysis
DATAOUTDIR="$WORKINGDIR"/"$DATADIR"_Out
#$SCRATCH/humann2_MT_Analysis/trimMT_Out

### Setup the $SCRATCH Dir ###
mkdir $WORKINGDIR
cp -r $DATA $WORKINGDIR
#$PROJECT/benjijp/trimMT -> $SCRATCH/humann2_MT_Analysis/trimMT
cd $WORKINGDIR

# Setup the Utility Mapping Database
UTILITYDB="$WORKINGDIR"/humann2UtilityDB
#$SCRATCH/humann2_MT_Analysis/humann2UtilityDB
humann2_databases --download utility_mapping full $UTILITYDB
# Setup the UniRef50 Protein Database
UNIREF50DB="$WORKINGDIR"/humann2UniRef50
#$SRATCH/humann2UniRef50
humann2_databases --download uniref uniref50_diamond $UNIREF50DB
# Prepare concatenated read files

### Compute Results ###
# Humann2 Species Agnostic Analysis
# Omitting nucleotide search of taxonomic Database
# Produces count data for feature in the UniRef50 protein cluster Database
# Uses translated search with Diamond protein aligner
TRIMMGWORKING="$WORKINGDIR"/"$DATADIR"
#SCRATCH/humann2_MT_Analysis/trimMT
FASTQCDIR="$WORKINGDIR"/fastqc_Out
#$SCRATCH/humann2_MG_Analysis/fastqc_Out
mkdir $FASTQCDIR
cd $DATADIR
for SAMPLEDIR in $(ls $TRIMMGWORKING/);
do
  cd $SAMPLEDIR
  # Merge Reads, Paired and Unpaired, and run fastqc on them
  MERGEDREADS="$SAMPLEDIR".fastq.gz
  cat "$SAMPLEDIR"*.fastq.gz > $MERGEDREADS
  FASTQCOUT="$FASTQCDIR"/"$SAMPLEDIR"_fastqc
  #$SCRATCH/humann2_MG_Analysis/Fastqc_Out/SAMPLEDIR_fastqc
  mkdir $FASTQCOUT
  fastqc -o $FASTQCOUT -t $THREADS $MERGEDREADS

  # Options for humann2 core algorithm
  humann2 --verbose --input $MERGEDREADS --output $DATAOUTDIR --bypass-nucleotide-search --protein-database "$UNIREF50DB"/uniref --search-mode uniref50 --o-log $MERGEDREADS.log --remove-temp-output --threads $THREADS --remove-stratified-output --memory-use maximum

  cd ..
done

cd $WORKINGDIR
cd $DATAOUTDIR
# Join output tables
MERGEDTABLE=BBMT.merged
humann2_join_tables --input $DATAOUTDIR --output "$MERGEDTABLE".genefamilies.tsv --file_name genefamilies
humann2_join_tables --input $DATAOUTDIR --output "$MERGEDTABLE".pathcoverage.tsv --file_name pathcoverage
humann2_join_tables --input $DATAOUTDIR --output "$MERGEDTABLE".pathabundance.tsv --file_name pathabundance

humann2_renorm_table -i "$MERGEDTABLE".genefamilies.tsv -o "$MERGEDTABLE".genefamilies.cpm.tsv --units cpm --update-snames
humann2_renorm_table -i "$MERGEDTABLE".pathabundance.tsv -o "$MERGEDTABLE".pathabundance.cpm.tsv --units cpm --update-snames

# Regrouping and renameing the tables
# EC level 4
humann2_regroup_table --input "$MERGEDTABLE".genefamilies.cpm.tsv --output "$MERGEDTABLE".genefamilies.cpm.EC4.tsv --groups uniref50_level4ec
humann2_rename_table --input "$MERGEDTABLE".genefamilies.cpm.EC4.tsv --output "$MERGEDTABLE".genefamilies.cpm.named.EC4.tsv --names ec
# EggNOG
humann2_regroup_table --input "$MERGEDTABLE".genefamilies.cpm.tsv --output "$MERGEDTABLE".genefamilies.cpm.eggnog.tsv --groups uniref50_eggnog
humann2_rename_table --input "$MERGEDTABLE".genefamilies.cpm.eggnog.tsv --output "$MERGEDTABLE".genefamilies.cpm.named.eggnog.tsv --names eggnog
# KEGG
humann2_regroup_table --input "$MERGEDTABLE".genefamilies.cpm.tsv --output "$MERGEDTABLE".genefamilies.cpm.KO.tsv --groups uniref50_ko
humann2_rename_table --input "$MERGEDTABLE".genefamilies.cpm.KO.tsv --output "$MERGEDTABLE".genefamilies.cpm.named.KO.tsv --names kegg-orthology
# Pfams
humann2_regroup_table --input "$MERGEDTABLE".genefamilies.cpm.tsv --output "$MERGEDTABLE".genefamilies.cpm.KO.tsv --groups uniref50_pfam
humann2_rename_table --input "$MERGEDTABLE".genefamilies.cpm.tsv --output "$MERGEDTABLE".genefamilies.cpm.named.pfam.tsv --names pfam
### Clean Up the Scratch ###
cd $SCRATCH
mv $WORKINGDIR $PROJECT
exit

