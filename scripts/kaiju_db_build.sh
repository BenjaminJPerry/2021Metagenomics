#!/bin/bash
#SBATCH --time=10:00:00
#SBATCH --account=def-camerand
#SBATCH --job-name=kaijudb
#SBATCH --mem=0
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32

### Downloading and building the Kaiju Database into projects/db/kaiju

# Prepare Environment
module load nixpkgs/16.09  gcc/5.4.0 kaiju/1.6.2

#Prepare SCRATCH
cd $SCRATCH
mkdir kaijudb
cd kaijudb

#build kaiju database
makeDB.sh -t 32 -e

#clean up
cd ..
mv kaijudb "$PROJECT"/benjijp
