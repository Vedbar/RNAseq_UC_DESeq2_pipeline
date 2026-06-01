setwd("F:/Chris_Ulcerative_Colitis/SRR646/4_DEGs")
library(DESeq2)
dir()
# Example: reading count data and sample information
countData <- as.matrix(read.csv("gene_count_matrix.csv", row.names=1))
colData <- read.csv("Metadata_SRR646.csv", row.names=1)

head(colData)
dds <- DESeqDataSetFromMatrix(countData = countData,
                              colData = colData,
                              design = ~ diagnosis)
dds$diagnosis


keep <- rowSums(counts(dds)) >= 10
#keep <- rowSums(counts(dds)) >= 0 # for CPM
dds <- dds[keep,]

dds <- DESeq(dds)
#############################
############################

# Compute CPM (counts per million)
# Get normalized counts (size-factor normalized counts)
norm_counts <- counts(dds, normalized=TRUE)

# Convert to CPM by scaling normalized counts
total_counts <- colSums(norm_counts)
cpm <- t(t(norm_counts) / total_counts * 1e6)

# Check the top CPM values
head(cpm)
write.csv(cpm, file="CPM_SRR646.csv")

#############################
############################
#############################
############################

# Results for UC vs Control
res_UC_vs_Control <- results(dds, contrast=c("diagnosis", "Ulcerative_Colitis", "Control"))

# Display summary of results for UC vs Control
summary(res_UC_vs_Control)
# Order by adjusted p-value for UC vs Control
resOrdered_UC_vs_Control <- res_UC_vs_Control[order(res_UC_vs_Control$padj),]
# View top results for UC vs Control
head(resOrdered_UC_vs_Control)

################################################
# Plotting

# MA-plot for CD vs Control
plotMA(res_CD_vs_Control, ylim=c(-2,2))
# Volcano plot for CD vs Control
with(res_CD_vs_Control, plot(log2FoldChange, -log10(pvalue), pch=20, main="Volcano plot CD vs Control"))

# MA-plot for UC vs Control
plotMA(res_UC_vs_Control, ylim=c(-2,2))

# Volcano plot for UC vs Control
with(res_UC_vs_Control, plot(log2FoldChange, -log10(pvalue), pch=20, main="Volcano plot UC vs Control"))

################################################
# Saving Results

#write.csv(as.data.frame(resOrdered_CD_vs_Control), file="deseq2_results_CD_vs_Control.csv")
write.csv(as.data.frame(resOrdered_UC_vs_Control), file="deseq2_results_UC_vs_Control.csv")
################################################

# PCA

library(ggplot2)
library(cowplot)
# Perform variance stabilizing transformation
vsd <- vst(dds, blind=FALSE)

# PCA plot
pcaData <- plotPCA(vsd, intgroup="diagnosis", returnData=TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))

ggplot(pcaData, aes(x=PC1, y=PC2, color=diagnosis)) +
  geom_point(size=3) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  ggtitle("PCA Plot") +
  theme_minimal()

################################################
# MDS

library(limma)

# Calculate Euclidean distances between samples
distMatrix <- dist(t(assay(vsd)))

# Perform classical multidimensional scaling (MDS)
mdsData <- cmdscale(distMatrix, k=2)
mdsData <- as.data.frame(mdsData)
colnames(mdsData) <- c("Dim1", "Dim2")
mdsData$diagnosis <- colData(dds)$diagnosis

ggplot(mdsData, aes(x=Dim1, y=Dim2, color=diagnosis)) +
  geom_point(size=3) +
  xlab("Dimension 1") +
  ylab("Dimension 2") +
  ggtitle("MDS Plot") +
  theme_minimal()
