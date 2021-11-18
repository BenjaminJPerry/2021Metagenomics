#!/bin/bash
#SBATCH --time=10:00:00
#SBATCH --account=def-camerand
#SBATCH --job-name=krakendb
#SBATCH --mem=256000M
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32

#Setup Environment
module load nixpkgs/16.09 intel/2016.4 kraken/1.1 jellyfish/1.1.11

#Setup Scratch
cd $SCRATCH
mkdir krakendb

# building kraken Database
kraken-build --standard --threads 32 --db krakendb

kraken-build --db krakendb --clean

#Clean up
mv krakendb "$PROJECT"/benjijp
