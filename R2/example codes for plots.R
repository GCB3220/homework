# draw pie chart of genomic distributions of Oct4 peaks
annot <- read.delim("Oct4_annot.txt",sep = '\t',header = T, na.strings = "")
pos <- annot$Annotation
pos <- sub(" (.*)",'',pos,perl = T)
table(pos)
pie(table(pos))

#draw average profiles of Oct4, H3K4me1 and H3K4me3 around Oct4 peaks
prof <- read.table("Oct4_H3K4me1_H3K4me3_profile.txt",header = T,sep='\t',na.strings = "")
library(ggplot2)
library(dplyr)
library(tidyr)
prof <- prof[,c(1,2,5,8)]
names(prof) <- c("pos",'Oct4','H3K4me1',"H3K4me3")
prof<- gather(prof, key = "factor", value = "density",-1)
ggplot(data = prof, aes(x=pos,y=density,color=factor)) + geom_line()

#draw meta profile of H3K4me1 and H3K4me3
metaGene <- read.table("H3K4me1_H3K4me3_metaGene_profile.txt",header = T,sep='\t',na.strings = "")
metaGene <- metaGene[,c(1,2,5)]
names(metaGene) <- c("pos",'H3K4me1',"H3K4me3")
metaGene<- gather(metaGene, key = "factor", value = "density",-1)
ggplot(data = metaGene, aes(x=pos,y=density,color=factor)) + geom_line() + geom_vline(xintercept = 0, linetype="dotted")

#draw heatmap of Oct4, H3K4me1 and H3K4me3 around Oct4 peaks
#It is impossible to put heatmaps side by side as shown in the guideline, you can generate individual heatmaps and put them together in powerpoint
hm <- read.table("Oct4_H3K4me1_H3K4me3_hm.txt",header = T,sep='\t',na.strings = "",row.names = 1)
library(pheatmap)
hm <- arrange(hm,X.1250)
colfunc1 <- colorRampPalette(c('white', 'red'))
colfunc2 <- colorRampPalette(c('white', 'blue'))
colfunc3 <- colorRampPalette(c('white', 'green'))
#heatmap of Oct4
pheatmap(hm[,1:201],scale = "none", cluster_rows = F, cluster_cols = F,show_rownames = F, show_colnames = F, color = colfunc1(200), legend = F)
#heatmap of H3K4me1
pheatmap(hm[,202:402],scale = "none", cluster_rows = F, cluster_cols = F,show_rownames = F, show_colnames = F, color = colfunc2(200), legend = F)
#heatmap of H3K4me3
pheatmap(hm[,403:603],scale = "none", cluster_rows = F, cluster_cols = F,show_rownames = F, show_colnames = F, color = colfunc3(200), legend = F)

