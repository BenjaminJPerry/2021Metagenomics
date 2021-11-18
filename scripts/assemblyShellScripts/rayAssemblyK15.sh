#!/bin/bash
#PBS -S /bin/bash
## procs should be a multiple of 16
## pmem (per core memory) should avoid multiple of 8 GB
#PBS -l pmem=8190mb
#PBS -l procs=32
#PBS -l walltime=72:00:00
#PBS -m bea
#PBS -M benjamin.j.perry@gmail.com

cd $UV_DATA
cd AAFCBBMG

#Load Ray Module
module load application/Ray/2.3.1

echo -e "Starting Metagenome Assembly"

###Pipeline Stuff for Later

# Specify a base input file name
#BASEIN=HI.4092.007.NS_adaptor_13.
#SAMPLEIN=2_BB2_PrPest_2
zcat BB2_PrPest_2_Q20Trim_1P.fastq.gz > R1Q20.fastq
zcat BB2_PrPest_2_Q20Trim_2P.fastq.gz > R2Q20.fastq

echo "Running on `hostname`"
echo "Using Ray version: `mpiexec_mpt Ray -version`"

mpiexec -n 32 Ray Meta -k 15 -p R1Q20.fastq R2Q20.fastq -o 2_BB2_PrPest_2_RayQ20K15

rm R1Q20.fastq
rm R2Q20.fastq