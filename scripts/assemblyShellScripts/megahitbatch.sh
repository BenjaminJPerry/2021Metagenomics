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
cd data

#module load application/SPAdes/3.10.0
#module load application/minia/v2.0.7
module load application/megahit/1.1.1
#module load application/Ray/2.3.1

##testing spades implemenation
#spades.py --test

echo -e "\n\n\n"
echo -e "Starting Metagenome Assembly"
echo -e "\n\n\n"

# Specify a base input file name
#BASEIN=HI.4092.007.NS_adaptor_13.
#SAMPLEIN=2_BB2_PrPest_2
#IN1=BB2_PrPest_2_Q20Trim_1P.fastq.gz
#IN2=BB2_PrPest_2_Q20Trim_2P.fastq.gz

echo "Running on `hostname`"
#cho "Using SPAdes version: `spades.py -v`"

# Starting metagenome assembly with up to 250 GB of memory.

echo "Starting run at `date`"
megahit -1 BB1_PoPest_1_1P.fastq.gz,BB1_PoPest_3_1P.fastq.gz,BB1_PoPest_5_1P.fastq.gz -2 BB1_PoPest_1_2P.fastq.gz,BB1_PoPest_3_2P.fastq.gz,BB1_PoPest_5_2P.fastq.gz --read BB1_PoPest_1_1U.fastq.gz,BB1_PoPest_1_2U.fastq.gz,BB1_PoPest_3_1U.fastq.gz,BB1_PoPest_3_2U.fastq.gz,BB1_PoPest_5_1U.fastq.gz,BB1_PoPest_5_2U.fastq.gz --verbose –k-min 21 –k-max 81 –k-step 4 -m 0.9 -t 32 -o BB1_PoPest_meghit_Q20
echo "Finished run at `date`"