# Arashi Server
# Running Hisat2 Alignments

# reference genome
REF=/home/vkhadka/Programs/A_REF/Human_genome_GRCh38/genome/Homo_sapiens.GRCh38.chr.toplevel.fa

# GTF file
GTF=/home/vkhadka/Programs/A_REF/Human_genome_GRCh38/Homo_sapiens.GRCh38.98.chr.gtf


# Index name
IDX=/home/vkhadka/Programs/A_REF/Human_genome_GRCh38/genome/Homo_sapiens

mkdir -p /home/vkhadka/Projects_2024/Chris_UC_RNAseq/filtered/Alignment
mkdir -p /home/vkhadka/Projects_2024/Chris_UC_RNAseq/filtered/Alignment/Logs

cd /home/vkhadka/Projects_2024/Chris_UC_RNAseq/filtered


# Aligning the data
for file in *1.fastq.gz; do
 echo "Running right trimming: ${file%%.*}"
 hisat2 -p 20 -x $IDX -1 $file -2 "${file%1.fastq.gz}2.fastq.gz" -S Alignment/${file%_trimmed_1.fastq.gz}.sam --summary-file Alignment/Logs/${file%_trimmed_1.fastq.gz}.log.txt


 echo "Running samtools on $file"
 samtools sort -@ 20 -o Alignment/${file%_trimmed_1.fastq.gz}.bam Alignment/${file%_trimmed_1.fastq.gz}.sam

 echo "Running htseq-count on $file"
 htseq-count -n 20 --format bam --order pos --mode union --type exon --idattr gene_id Alignment/${file%_trimmed_1.fastq.gz}.bam $GTF > Alignment/${file%_trimmed_1.fastq.gz}.tsv

done
