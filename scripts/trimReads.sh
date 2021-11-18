#!/bin/bash
##Shell Script for Trimming with fastqc and evaluating trimmed files with fastqc
cd TrimReads
SAMPLES=($(ls -d *))
for SAMPLE in "${SAMPLES[@]}"
do
	echo $SAMPLE

	### Move into the subdirectory
	cd $SAMPLE
	ls -lh

	### Run Trimmomatic on Reads
	READ1="*"$SAMPLE"_R1.fastq.gz"
	READ2="*"$SAMPLE"_R2.fastq.gz"
	BASE=$SAMPLE".fastq.gz"
	echo $READ1
	echo $READ2

	java -jar /home/imss/tools/Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads 6 $READ1 $READ2 -baseout $BASE HEADCROP:5 TRAILING:20 SLIDINGWINDOW:10:20 MINLEN:60

	FASTQ1="$SAMPLE_1U.fastq.gz"
	FASTQ2="$SAMPLE_2U.fastq.gz"
	FASTQ3="SAMPLE_1P.fastq.gz"
	FASTQ4="SAMPLE_2P.fastq.gz"

	### Run FastQC on the Paired and Unpaired Read Files
	fastqc $FASTQ1
	fastqc $FASTQ2
	fastqc $FASTQ3
	fastqc $FASTQ4

	### Move Back to Reads Root Directory
	cd ..

done
