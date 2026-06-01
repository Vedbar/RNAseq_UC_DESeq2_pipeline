#!/bin/bash

# Define the directory where your FASTQ files are located
fastq_directory="/home/vkhadka/Projects_2024/Chris_UC_RNAseq/FASTQ_SRR646"


# Loop through each FASTQ file in the directory
for fastq_file in "$fastq_directory"/SRR*.fastq.gz; do
    # Extract the filename without the directory path
    filename=$(basename "$fastq_file" .fastq.gz)

    # Check if FastQC output files exist
    if [ ! -f "$fastq_directory/QC_raw/${filename}_fastqc.html" ]; then
        # Run FastQC if output files don't exist
        fastqc -o "$fastq_directory/QC_raw" "$fastq_file"
    else
        echo "FastQC has already been run on $filename."
    fi
done
