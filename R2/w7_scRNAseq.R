install.packages('BiocManager')
BiocManager::install('multtest')
install.packages('Seurat')

library(Seurat)
library(dplyr)
library(patchwork)
library(Matrix)

pbmc.data <- Read10X(data.dir = "hg19/")
pbmc <- CreateSeuratObject(counts = pbmc.data, project = "pbmc3k")

class(pbmc.data)
dim(pbmc.data)
pbmc.data[1:6,1:6]
slotNames(pbmc)

pbmc = CreateSeuratObject(counts = pbmc.data, project = "pbmc",
                          min.cells = 3, min.features = 200)

pbmc[["percent.mt"]] = PercentageFeatureSet(pbmc, pattern = "^MT-")
head(pbmc@meta.data, 5)

VlnPlot(pbmc, features = c("nFeature_RNA", "nCount_RNA",
                           "percent.mt"), ncol = 3)
summary(pbmc[["nFeature_RNA"]])
summary(pbmc[["nCount_RNA"]])
summary(pbmc[["percent.mt"]])

plot1 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 =
                          "percent.mt")
plot2 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 =
                          "nFeature_RNA")
plot1 + plot2
pbmc = subset(pbmc, subset = nFeature_RNA > 200 & nFeature_RNA <6000 &
                percent.mt < 6)
dim(pbmc)

pbmc = NormalizeData(pbmc, normalization.method = "LogNormalize",
                     scale.factor = 10000)
pbmc <- NormalizeData(pbmc)

pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures
                             = 2000)
top10 <- head(VariableFeatures(pbmc), 10)
plot1 <- VariableFeaturePlot(pbmc)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
plot1 + plot2

all.genes = rownames(pbmc)
pbmc = ScaleData(pbmc, features = all.genes)

pbmc = RunPCA(pbmc, features = VariableFeatures(object = pbmc))
print(pbmc[["pca"]], dims = 1:5, nfeatures = 5)
VizDimLoadings(pbmc, dims = 1:2, reduction = "pca")
DimPlot(pbmc, reduction = "pca")
DimHeatmap(pbmc, dims = 1, cells = 500, balanced = TRUE)
DimHeatmap(pbmc, dims = 1:15, cells = 500, balanced = TRUE)

ElbowPlot(pbmc)

pbmc = FindNeighbors(pbmc, dims = 1:17)
pbmc = FindClusters(pbmc, resolution = 0.5)
head(Idents(pbmc), 5)

pbmc = RunTSNE(pbmc, dims = 1:17)
DimPlot(pbmc, reduction = "tsne")
# reticulate::py_install(packages = 'umap-learn')
pbmc = RunUMAP(pbmc, dims = 1:17)
DimPlot(pbmc, reduction = "umap")

FeaturePlot(pbmc, features = c("CD86"))
VlnPlot(pbmc, features = c("CD86"), slot = "counts", log = TRUE)

VlnPlot(pbmc, features = c("CD86", "MS4A1", "CD79A"))

cluster0.markers <- FindMarkers(pbmc, ident.1 = 0, min.pct = 0.25)
head(cluster0.markers, n = 5)

cluster5.markers <- FindMarkers(pbmc, ident.1 = 5, ident.2 = c(0, 3),
                                min.pct = 0.25)
head(cluster5.markers, n = 5)
pbmc.markers <- FindAllMarkers(pbmc, only.pos = TRUE, min.pct = 0.25,
                               logfc.threshold = 0.25)
FeaturePlot(pbmc, features = c("MS4A1", "GNLY", "CD3E", "CD14", "FCER1A",
                               "FCGR3A", "LYZ", "PPBP","CD8A"))
VlnPlot(pbmc, features = c("MS4A1", "GNLY", "CD3E", "CD14", "FCER1A",
                           "FCGR3A", "LYZ", "PPBP","CD8A"), slot = "counts", log = TRUE)

pbmc.markers %>%
  group_by(cluster) %>%
  top_n(n = 10, wt = avg_log2FC) -> top10
DoHeatmap(pbmc, features = top10$gene) + NoLegend()
  