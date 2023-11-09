# task1 清理数据
diamond_sample <- read.csv("week7 Rdata_diamonds_samples100_mdf.csv")
# data type
head(diamond_sample$X)
typeof(diamond_sample$X)
class(diamond_sample$X)
head(diamond_sample$cut)
class(diamond_sample$cut)
cut.chr=as.character(diamond_sample$cut)
head(cut.chr)
class(cut.chr)
# integer:加L表纯整数/numeric
class(c(2L, 3L))
# any missing?
anyNA(diamond_sample)
sum(which(diamond_sample == ""))
# any duplicated?
sum(duplicated(diamond_sample))
# strange patterns
str(diamond_sample$x)
table(diamond_sample$x)
library(dplyr)
diamond_sample$volume = 
  diamond_sample$x * diamond_sample$y * diamond_sample$z
diamond_sample$volume <- round(diamond_sample$volume, 2)
head(diamond_sample)
# 绘制图来排除异常项
plot(x = diamond_sample$carat, y = diamond_sample$volume,
     pch = 20, col = "darkgoldenrod4",
     las = 1, xlab = "carat", ylab = "volume",
     main = "diamond carat ~ volume", bty = "l")
# 批注
text(diamond_sample$carat, diamond_sample$volume,
     labels = diamond_sample$X, col = "dimgray",
     cex = 0.7, pos =4)
# 删除异常项
diamond_sample <- diamond_sample %>%
  subset(diamond_sample$X != 9) # 9一定有问题, 1不一定
dim(diamond_sample)
table(diamond_sample$cut)
# 绘图
plot(x = diamond_sample$carat,
     y = diamond_sample$price,
     pch = 20, col = "darkslateblue",
     las = 1, xlab = "carat", ylab = "price",
     main = "diamond carat ~ price")

text(diamond_sample$carat,
     diamond_sample$price,
     labels = diamond_sample$X,
     col = "dimgray",
     cex = 0.7, pos = 4)
    
library(ggplot2)
p = ggplot(diamond_sample, aes(x = carat,y = price))
p+geom_point(alpha=0.6) + facet_grid(clarity~.)




# 保存删除
remove()
save.image("week7_practice.RData")
