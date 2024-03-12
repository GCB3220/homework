# 下载DESeq2包
if (!requireNamespace("BiocManager", quietly = TRUE)) 
  install.packages("BiocManager")

BiocManager::install("DESeq2")

library(DESeq2)

# 读取文件
trying <- try(readcount <- read.delim("naive_primed_hESC_RNAseq_readcount.txt"))
if(is(trying, "try-error")){
  download.file(url = paste0("https://raw.githubusercontent.com/hugocarlos/public_scripts/",
                             "master/teaching/naive_primed_hESC_RNAseq_readcount.txt"),
                destfile = "naive_primed_hESC_RNAseq_readcount.txt")
  readcount <- read.delim("naive_primed_hESC_RNAseq_readcount.txt")
}

# 各基因计数-> 相同幅度，均匀测序
total_cov <- apply(readcount[ , -9], 2, sum) # Sums read counts column-wise
total_cov <- data.frame(Sample_name = names(total_cov), Count = total_cov)
library(ggplot2)
ggplot(total_cov, aes(x = Sample_name, y = Count, fill = Sample_name)) +
  geom_bar(stat = "identity") +
  ylab("Total counts over genes") +
  scale_fill_manual(values = c("paleturquoise1", "paleturquoise2",
                               "paleturquoise3", "paleturquoise4",
                               "rosybrown1", "rosybrown2",
                               "rosybrown3", "rosybrown4")) +
  theme(axis.text.x = element_text(angle = 90), legend.position = "none")

# 各样本中涉及基因种类：相近
genecovered <- apply(readcount[ , -9], 2, function(x) sum(x > 0))
genecovered <- data.frame(Sample_name = names(genecovered), Count = genecovered)
ggplot(genecovered, aes(x = Sample_name, y = Count, fill = Sample_name)) +
  geom_bar(stat = "identity") +
  ylab("Number of covered genes") +
  scale_fill_manual(values = c("palegreen1", "palegreen2", "palegreen3", "palegreen4",
                               "royalblue1", "royalblue2", "royalblue3", "royalblue4")) +
  theme(axis.text.x = element_text(angle = 90), legend.position = "none")

# RPKM:reads per kilobases per million
rpk <- readcount / readcount$exonlength * 10^3
# 矩阵初始化
rpkm <- rpk[ , -9]
for (i in 1:8){
  rpkm[ , i] <- (rpk[ , i] / total_cov$Count[i]) * 10^6
}
head(rpkm)

# 导入数据
readcount <- read.table("naive_primed_hESC_RNAseq_readcount.txt",
                        header = TRUE, row.names = 1)
configure <- data.frame(condition = factor(c("naive", "naive", "naive", "naive",
                                             "primed", "primed", "primed", "primed")),
                        type = c("r1", "r2", "r3", "r4", "r1", "r2", "r3", "r4"))
(dds <- DESeqDataSetFromMatrix(countData = readcount[ , -9],
                               colData = configure,
                               design = ~ condition))

# 方差齐化（为了后续分析）
head(assay(dds), 3)
variance_per_gene <- apply(assay(dds), 1, var)
mean_count_per_gene <- apply(assay(dds), 1, mean)
df <- data.frame(genes = row.names(assay(dds)),
                 mean_counts = mean_count_per_gene,
                 variance_counts = variance_per_gene)
g <- ggplot(df, aes(x = mean_counts, y = variance_counts)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10() +
  geom_abline(slope = 1, col = "red")
#平均数与方差关系
g

# VST/rlog 转换数据
vsd <- vst(dds, blind = FALSE)
head(assay(vsd), 3)
colData(vsd)
rld = rlog(dds, blind = FALSE)
head(assay(rld), 3)
colData(rld)

dds <- estimateSizeFactors(dds)
# size factor和
plot(sizeFactors(dds), colSums(counts(dds)),
     ylim = range(union(colSums(counts(dds)),
     colSums(counts(dds, normalized = TRUE)))))
points(sizeFactors(dds), colSums(counts(dds, normalized = TRUE)), col = "red")
# 三种对比
library(tidyverse)
df <- bind_rows(
  as_tibble(log2(counts(dds, normalized = TRUE)[ , 1:2] + 1))
  %>% mutate(transformation = "log2(x + 1)"),
  as_tibble(assay(vsd)[ , 1:2]) %>% mutate(transformation = "vst"),
  as_tibble(assay(rld)[ , 1:2]) %>% mutate(transformation = "rlog"))
colnames(df)[1:2] <- c("x", "y")
ggplot(df, aes(x = x, y = y)) +
  geom_hex(bins = 80) +
  coord_fixed() +
  facet_grid( . ~ transformation) +
  geom_abline(slope = 1, col = "red", size = 0.2)

# Euclidean distance between samples
sampleDists <- dist(t(assay(vsd)))
sampleDists
sampleDistMatrix <- as.matrix(sampleDists)
# 热图
library(RColorBrewer)
library(pheatmap)
colors <- colorRampPalette(rev(brewer.pal(9, "Blues")) )(255)
pheatmap::pheatmap(sampleDistMatrix,
                   clustering_distance_rows = sampleDists,
                   clustering_distance_cols = sampleDists,
                   col = colors)
plotPCA(vsd) + theme_bw()

# 数据预过滤+padj
dim(counts(dds))
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep, ]
dim(counts(dds))
dds <- DESeq(dds)
plotDispEsts(dds)
res <- results(dds)
res
write.table(res, file = "hESC_DESeq2_output.txt", sep = "\t")
summary(res)
res_05 <- results(dds, alpha = 0.05)
table(res_05$padj < 0.05)
summary(res_05)
resLFC2 <- results(dds, lfcThreshold = 2)
table(resLFC2$padj < 0.1)
summary(resLFC2)
resBoth <- results(dds, lfcThreshold = 2, alpha = 0.05)
summary(resBoth)

# 多种测试
sum(res$pvalue < 0.05, na.rm = TRUE)
sum(!is.na(res$pvalue))
sum(res$padj < 0.05, na.rm = TRUE)
resSig <- subset(res, padj < 0.05)
head(resSig[order(resSig$log2FoldChange), ])
head(resSig[order(resSig$log2FoldChange, decreasing = TRUE), ])

# 数据可视化
topGene <- rownames(res)[which.min(res$padj)]
plotCounts(dds, gene = topGene)
d <- plotCounts(dds, gene = topGene, intgroup = "condition", returnData = TRUE)
ggplot(d, aes(x = condition, y = count, color = condition)) +
  geom_point(position = position_jitter(w = 0.1, h = 0)) +
  ggrepel::geom_text_repel(aes(label = rownames(d))) +
  theme_bw() +
  ggtitle(topGene) +
  theme(plot.title = element_text(hjust = 0.5))
plotMA(res)
res_subsample <- res[which(res$baseMean < 10), ]
abline(h = 1, col = "red")
plot(x = res_subsample$baseMean, y = res_subsample$log2FoldChange)
abline(h = 0, col = "red")
hist(res$pvalue[res$baseMean > 1], breaks = 0:20/20,
     col = "grey50", border = "white",
     xlab = "p-value",
     main = "Histogram of the p-values for genes with baseMean > 1")
topVarGenes <- head(order(genefilter::rowVars(assay(vsd)), decreasing = TRUE), 20)
mat <- assay(vsd)[topVarGenes, ]
pheatmap(mat)
mat <- mat - rowMeans(mat)
pheatmap(mat)
mat <- rpkm[topVarGenes, ]
pheatmap(mat)
pheatmap(log2(mat+1))
