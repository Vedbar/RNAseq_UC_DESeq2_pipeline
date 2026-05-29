# RNA-seq analysis pipeline for ulcerative colitis study

This repository contains scripts used for RNA-seq preprocessing, alignment, gene-level read counting, and differential expression analysis.

## Overview

The pipeline includes:

1. Quality control on FASTQ files using FastQC
2. Quality filtering using Trimmomatic
3. Alignment to human GRCh38 using HISAT2
4. BAM sorting using SAMtools
5. Gene-level read counting using HTSeq-count
6. Differential expression analysis using DESeq2

## Input data

Raw paired-end FASTQ files were obtained from public RNA-seq datasets. Files should be named as:

Sample_1.fastq.gz
Sample_2.fastq.gz

## Reference genome and annotation

Reference genome: Homo sapiens GRCh38  
Annotation file: Homo_sapiens.GRCh38.98.chr.gtf

## Scripts
- `1_code_fastqc.sh`: read QC
- `2_code_trim.sh`: read trimming and quality filtering
- `3_alignment_code.sh`: HISAT2 alignment, SAMtools sorting, and HTSeq-count
- `4_DESeq_code.R`: DESeq2 normalization, differential expression, PCA, and MDS

## DESeq2 model

The DESeq2 design formula was:

```r
design = ~ diagnosis

contrast = c("diagnosis", "Ulcerative_Colitis", "Control")
