#!/bin/bash
### Kaiju Analysis Pipeline

BASEOUT=out_kaiju/


for SAMPLE in $(ls);
do

  # default
  kaiju -z 25 -t nodes.dmp -f kaiju_db.fmi -i inputfile.fastq -o "$BASEOUT$SAMPLE"

  # Greedy matching here will allow 3 mismatches (5% of 60bp min read length) and does not report reads below p value 0.05
  kaiju -5 16 -t nodes.dmp -f kaiju_db.fmi -i inputfile.fastq -a greedy -e 3 -E 0.05

done
