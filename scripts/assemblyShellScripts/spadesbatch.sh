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

module load application/SPAdes/3.10.0
#module load application/minia/v2.0.7
#module load application/megahit/1.1.1
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
echo "Using SPAdes version: `spades.py -v`"

# Starting metagenome assembly with up to 250 GB of memory.

echo "Starting run at `date`"
spades.py -k 21,35,53,55,57,65,67,69,71 -t 32 -m 250 --meta -dataset spadesin.yaml -o BB1_PoPest_135_spadesAssembly_Q20
echo "Finished run at `date`"
