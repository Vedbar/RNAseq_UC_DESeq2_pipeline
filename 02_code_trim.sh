#!/bin/bash

# Define function to perform trimming for a single file
perform_trimming() {
    file="$1"
    echo "Running trimming for: $file"
    trimmomatic PE "$file" "${file%_1.fastq.gz}_2.fastq.gz" \
        "${file%.fastq.gz}_1_trimmed.fastq.gz" "${file%.fastq.gz}_1_unpaired.fastq.gz" \
        "${file%.fastq.gz}_2_trimmed.fastq.gz" "${file%.fastq.gz}_2_unpaired.fastq.gz" \
        ILLUMINACLIP:adapters.fa:2:30:10 LEADING:30 TRAILING:30 AVGQUAL:30 MINLEN:20
}

# List all input fastq files
files=(*_1.fastq.gz)
ls *_1.fastq.gz > files

# Maximum number of files to process concurrently
max_processes=10

# Counter for the number of processes
process_count=0

# Run trimming for each file in parallel
for file in "${files[@]}"; do
    # Start trimming in background
    perform_trimming "$file" &
    ((process_count++))

    # If the maximum number of processes is reached, wait for them to finish
    if ((process_count >= max_processes)); then
        wait
        process_count=0
    fi
done

# Wait for any remaining background processes to finish
wait
