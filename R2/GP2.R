if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("DiffBind", force = TRUE)


library(DiffBind)

# 读取
dbObj <- dba(sampleSheet="Sample2.csv")
dbObj.count <- dba.count(dbObj, bUseSummarizeOverlaps = FALSE, bSubControl = TRUE, minCount = 1, filter=FALSE)
dbObj.contrast <- dba.contrast(dbObj.count, categories = DBA_TISSUE, minMembers = 2)
dba.show(dbObj.contrast, bContrasts = T)
dbObj.analyze <- dba.analyze(dbObj.contrast, method = DBA_DESEQ2)


dba.plotPCA(dbObj.analyze,  attributes=DBA_TISSUE, label=DBA_ID)
plot(dbObj.analyze)
dba.plotMA(dbObj.analyze)
dba.plotVenn(dbObj.analyze, 1:2)
dba.plotVolcano(dbObj.analyze)
dba.plotBox(dbObj.analyze)
dba.plotHeatmap(dbObj.analyze)

result <- dba.report(dbObj.analyze)
result <- as.data.frame(result)
write.csv(result, file = "diffbind.csv")
write.table(result, file = "a.interval", sep = "/t", quote = FALSE, row.names = FALSE)

res_sorted <- result[order(result$FDR), ]
df <- as.data.frame(res_sorted)
extrainfo <- NULL
for (i in seq_len(nrow(df))) {
  extrainfo[i] <- paste0(c(df$width[i], df[i, 6:ncol(df)]), collapse = "|")
}
res_sorted  <- data.frame(
  Chrom = seqnames(res_sorted),
  Start = start(res_sorted) - 1,
  End = end(res_sorted),
  Name = rep("DiffBind", length(res_sorted)),
  Score = rep("0", length(res_sorted)),
  Strand = gsub("\\*", ".", strand(res_sorted)),
  Comment = extrainfo
)

write.table(res_sorted, file = "a.interval", sep = "\t", quote = FALSE, row.names = FALSE)


library(ggplot2)

##ftp下载，原文是6.22但是ftp页面打不开，这里就使用更新的6.32
#http://ftp.ensembl.org/pub/release-107/fasta/drosophila_melanogaster/dna/
# http://ftp.ensembl.org/pub/release-107/gtf/drosophila_melanogaster/Drosophila_melanogaster.BDGP6.32.107.chr.gtf.gz

library(ChIPseeker)
library(org.Dm.eg.db)
library(TxDb.Dmelanogaster.UCSC.dm6.ensGene)
txdb <- TxDb.Dmelanogaster.UCSC.dm6.ensGene

diff <- readPeakFile("diffbind.interval")
# diff <- readPeakFile("a.interval")
# diff <- res_sorted
seqlevelsStyle(diff) <- seqlevelsStyle(txdb)
peakAnno <- annotatePeak(diff, TxDb = txdb, tssRegion = c(3000, -3000),flankDistance=5000, annoDb = "org.Dm.eg.db")
df_diff <- as.data.frame(peakAnno)
plotAnnoPie(peakAnno)
vennpie(peakAnno)
write.csv(peakAnno,file="peakanno.csv")




library(clusterProfiler)
gene<-read.csv("peakanno.csv")
symbol=gene$ENTREZID
enrich.go <- enrichGO(gene = symbol,  #待富集的基因列表
                      OrgDb = org.Dm.eg.db,  #指定物种的基因数据库，示例物种是绵羊（sheep）
                      keyType = 'ENTREZID',  #指定给定的基因名称类型，例如这里以 entrze id 为例
                      ont = 'ALL',  #GO Ontology，可选 BP、MF、CC，也可以指定 ALL 同时计算 3 者
                      # pAdjustMethod = 'fdr',  #指定 p 值校正方法
                      # pvalueCutoff = 0.05,  #指定 p 值阈值（可指定 1 以输出全部）
                      # qvalueCutoff = 0.2,  #指定 q 值阈值（可指定 1 以输出全部）
                      # readable = FALSE)
)


dotplot(enrich.go)
barplot(enrich.go)

kegg <- enrichKEGG(
  gene = symbol,  #基因列表文件中的基因名称
  keyType = 'ENTREZID',  #KEGG 富集
  organism = 'oas',  #例如，oas 代表绵羊，其它物种更改这行即可
  pAdjustMethod = 'fdr',  #指定 p 值校正方法
  pvalueCutoff = 0.05,  #指定 p 值阈值（可指定 1 以输出全部）
  qvalueCutoff = 0.2)  #指定 q 值阈值（可指定 1 以输出全部）



library(ChIPseeker)
library(dplyr)
chip <- readPeakFile("chipseeker.interval")
chip <-read.table(file = "chipseeker.interval",
                  header = TRUE,  # 如果文件有表头，设置为TRUE
                  sep = "\t",   # 指定分隔符为制表符
                  quote = "",   # 如果字段中不包含引号，设置为空字符串
                  fill = TRUE)

df <- as.data.frame(chip)
df <- df %>%
  mutate(geneID = sub(".*\\|([^|]+)$", "\\1", Comment))
write.csv(df$geneID, file="geneID.csv")
