# 清洗数据

# 1.screen+diagnose
# 数据内容(summary/attributes/head/table...)/长或宽格式?/格式是否要修改?
# 重复?缺失?(NA, duplicated)/列名是否合适?/数据类型,格式修改?/数据不正常?
# 2.treat+document
# 针对问题修改数据集+标注步骤原因
# 画图研究关系

# numeric vs integer


# task1
# 读取文件+探索
row_data_WNV <- read.csv("Week_7_WNV_mosquito_test_results.csv")
head(row_data_WNV, 10)
# 行数
nrow(row_data_WNV)
# 提供属性
attributes(row_data_WNV)
summary(row_data_WNV)
# 频率表是一种通过计算变量中每个唯一类别或级别的出现次数来汇总分类数据
table(row_data_WNV$YEAR)
# 对象的结构和数据类型
str(row_data_WNV)
class(row_data_WNV$TEST.DATE)
# 长格式数据高而窄，变量没有做明确的细分, 列中存在重复/冗余
# 1列为名称, 1列为变量值
# 如:名称 月份 KPI值
# 长格式有时在绘图中用到
# 宽格式数据宽，每行代表一个不同的实体，变量存储为单独的列。
# 如: 名称 1月KPI值 2月~...
# 所以为:?wide form
# 修改variable name library(dplyr)
library(tidyverse)
row_data_WNV <- row_data_WNV %>% rename("YEAR" = "SEASON.YEAR")
# colname 必须全上(列出所有colname名字)
colnames(row_data_WNV) <- "YEAR"


# solution:
# 重命名+改变test.date数据类型
row_data_WNV <- row_data_WNV %>%
  rename(YEAR = SEASON.YEAR) %>%
  relocate(1, 6) %>% # 将第6列移至第2列(1开始数)
  # mutate: 用于创造/修改数据框
  mutate(TEST.DATE = as.POSIXct(row_data_WNV$TEST.DATE, 
                                format = "%m/%d/%Y %H:%M:%S", # 原先格式
                                tz="America/Chicago"))
# POSIXct类型
dat1 <- row_data_WNV$TEST.DATE[1]
attributes(dat1)
dat1
attributes(dat1)$tzone <- "America/Los_Angeles"#自动换算
# 检查所有col
colnames(row_data_WNV)
for(i in c(1, 2, 4:ncol(row_data_WNV))){
  writeLines(colnames(row_data_WNV)[i])
  print(table(row_data_WNV[, i]))
  writeLines("\n")
}
# NUMBER.OF.MOSQUITOES只有一例77, 要注意
row_data_WNV[row_data_WNV$NUMBER.OF.MOSQUITOES> 70, ]
wnv <- row_data_WNV
# 寻找block对其影响
wnv_out <- which(wnv$NUMBER.OF.MOSQUITOES> 70)# 提供true索引
wnv_out_block <- wnv %>%
  slice(wnv_out) %>% #保留为true的行
  select(BLOCK) %>% unlist()# 制造向量
wnv %>%
  filter(BLOCK == wnv_out_block) #取符合条件子集
wnv %>%
  slice((wnv_out-4):(wnv_out+4)) # 截取周围
# location要分
wnv$LOCATION[wnv$LOCATION == ""] <- NA
wnv$LOCATION <- wnv$LOCATION %>%
  gsub(pattern= "[()]", replacement = "", wnv$LOCATION, perl = T)
#  perl:兼容正则表达式
wnv <- separate(data = wnv, col = LOCATION,
                into = c("LATITUDE", "LONGITUDE"),
                sep = ",", remove = F, fill = "left", convert = T)


# 检查missing value
anyNA(row_data_WNV)
# 检查重复行+修订数据
sum(duplicated((row_data_WNV)))
duplicate_row <- duplicated(row_data_WNV)
update_data_WNV <- subset(row_data_WNV, !duplicate_row)
# 去除"" (!=NA)
# 检查->所以""替换为FALSE(逻辑数据框)
empty_block <- row_data_WNV == "" 
sum(empty_block)
# 根据逗号前要求对数据帧进行子集化
empty_row <- update_data_WNV[empty_block, ] 
# 删除""
update_data_WNV <- subset(update_data_WNV, 
                          apply(update_data_WNV != "", 1, all))
anyNA(update_data_WNV)
str(update_data_WNV)
# diagnostic plots 诊断图
hist(x=update_data_WNV$TEST.ID)
# 如果需要，将数据结构从长数据结构转换为宽数据结构，反之亦然。
# 确保变量名称信息丰富且准确。
# as.POSIXct() -> 规范化时间
new_date <- as.POSIXct(update_data_WNV$TEST.DATE, 
                       format = "%m/%d/%Y %H:%M:%S", 
                       tz = "America/Chicago")
new_date[1]
str(new_date)
class(new_date[1])
attributes(new_date)
# 转换时区?
libra9ry(lubridate)
new_date <- with_tz(new_date, tzone = "America/Los_Angeles")
new_date[1]
# time/location规范化
update_data_WNV <- mutate(update_data_WNV, TEST.DATE = 
                            as.POSIXct(update_data_WNV$TEST.DATE,
                                       format = "%m/%d/%Y %H:%M:%S",
                                       tz="America/Chicago"))
update_data_WNV <- relocate(update_data_WNV, 1, 6)
# gsub:正则表达
update_data_WNV$LOCATION <- update_data_WNV$LOCATION %>%
  gsub(pattern= "[()]", replacement = "", update_data_WNV$LOCATION, 
       perl = T)
# 分两列
update_data_WNV <- separate(data = update_data_WNV, col = LOCATION,
                into = c("LATITUDE", "LONGITUDE"),
                sep = ",", remove = F, fill = "left", convert = T)
# 检查蚊子过多的组
wnv_out_block <- update_data_WNV %>%
  slice(which(update_data_WNV$NUMBER.OF.MOSQUITOES > 70)) %>%
  select(BLOCK) %>% unlist()
table(update_data_WNV$LOCATION) %>% head(3) %>% dimnames()


# 绘制关系图 -- ggplot
# 首先创建一个ggplot名为 的对象wnv_plot。
wnv_plot <- ggplot(data = wnv) +
  theme_classic()
# 添加boxplot
wnv_plot +
  geom_boxplot(mapping = aes(x = as.factor(YEAR), # factor:好画图
                             y = NUMBER.OF.MOSQUITOES))
# 
wnv_plot +
  geom_boxplot(mapping = aes(x = round(LATITUDE, 3),
                             y = NUMBER.OF.MOSQUITOES,
                             group = round(LATITUDE, 3)),
               position = "identity",
               outlier.shape = NA) +
  scale_x_continuous() #规范刻度
# 
wnv_plot +
  geom_boxplot(mapping = aes(x = round(LONGITUDE, 3),
                             y = NUMBER.OF.MOSQUITOES,
                             group = round(LONGITUDE, 3)),
               position = "identity",
               outlier.shape = NA) +
  scale_x_continuous()
# 
wnv_plot +
  geom_boxplot(mapping = aes(x = TRAP_TYPE,
                             y = NUMBER.OF.MOSQUITOES,
                             group = TRAP_TYPE),
               position = "identity")



# task 2
# 读txt
pgp3 <- read.table(file = "week_7_Tests_PGP3.txt", sep = "\t")
# 检查文件
head(pgp3, 10)
anyNA(pgp3)
sum(duplicated(pgp3))
pgp3[which(duplicated(pgp3)),] #查看重复
pgp3[which(pgp3$SampleID %in% c(2,7,46,201)),]
# 长形式,not tidy
pgp3 <- pgp3 %>%
  .[-which(duplicated(.)),] %>%
  spread(key = measured, value = value)#长变宽 == pivot_wider
str(pgp3)
# 观察
for(i in 1:ncol(pgp3)){
  if(i == 1){
    writeLines(colnames(pgp3)[i])
    writeLines("NAs in the column:")
    sum(is.na(pgp3[, i])) %>% print()
    writeLines("\n\n")
  }else{
    writeLines(colnames(pgp3)[i])
    table(pgp3[, i]) %>% print()
    writeLines("NAs in the column:")
    sum(is.na(pgp3[, i])) %>% print()
    writeLines("\n\n")
  }
}
table(pgp3[2, 3]) # 2行3列
# 修改性别标识
pgp3$sex[which(pgp3$sex == 1)] <- "Male"
pgp3$sex[which(pgp3$sex == 2)] <- "Female"
# ""替换为na
pgp3$age.f[pgp3$age.f == ""] <- NA
str(pgp3)
# 重组织
pgp3 <- pgp3 %>%
  mutate_at(.vars = c(1,2,5), .funs = as.factor) %>%
  mutate_at(.vars = c(3,4), .funs = as.numeric) %>%
  relocate(1,5,2,4,3) %>%
  # gather:变长数据:time.point代表之前变量的列, od代表值列
  # == pivot_longer
  gather(key = "Time.point", value = "OD", c(4,5)) %>%
  drop_na(c(2,3)) %>%
  mutate(Time.point = factor(Time.point, 
                             levels = c("elisa.pre.od", "elisa.od"), 
                             ordered = T)) %>%
  droplevels()# 去掉无用项
str(pgp3)
# 绘图
ggplot(data = pgp3, aes(x = age.f,
                        y = OD,
                        fill = Time.point)) +
  geom_boxplot(color = "black") +
  theme_classic() +
  # 自定义框的填充颜色
  scale_fill_manual(labels = c("elisa.pre.od", "elisa.od"),
                    name = "Measurement",
                   values = c("#ADD8E6", "#FF6347"),
                   # break:顺序
                   breaks = c("elisa.pre.od", "elisa.od")) + 
  # 图例的位置调整到绘图的右
  theme(legend.position = "right") +
  # 覆盖默认图例属性，将图例项的大小设置为 3。
  guides(color = guide_legend(override.aes = list(size = 3) ) )








# problem set
# task1 清理数据
diamond_sample <- read.csv("Rdata_diamonds_samples100_mdf.csv")
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
# char
var.char = c("Hello",",","world","!")
class(var.char)
# factor
var.fac = factor(c("mX","mX","high","low"),
                 levels=c("low","mX","high"))
print(var.fac)
# list
data.list=list(var.char,var.fac)
length(data.list)
dim(data.list) # 维度

# any missing?
anyNA(diamond_sample)
is.na(diamond_sample)
apply(is.na(diamond_sample), 2, which)
dim(diamond_sample)
sum(which(diamond_sample == ""))
data.noNA = diamond_sample[complete.cases(diamond_sample), ]
dim(data.noNA)
# any duplicated?
sum(duplicated(diamond_sample))
# strange patterns
str(diamond_sample$x)
table(diamond_sample$x)
library(dplyr)
# volume与carat关系
diamond_sample$volume = 
  diamond_sample$x * diamond_sample$y * diamond_sample$z
diamond_sample$volume <- round(diamond_sample$volume, 2)
head(diamond_sample)
# 绘制图来排除异常项
help(plot)
plot(x = diamond_sample$carat, y = diamond_sample$volume,
     pch = 20, col = "darkgoldenrod4",
     las = 1, xlab = "carat", ylab = "volume",
     main = "diamond carat ~ volume", bty = "l")
# pch: Plotting Character 绘图符号或点字符的类型(20:实心)
# las: Label Axis Style 控制轴标签的方向(1: 水平)
# bty: Box Type绘图周围绘制的框的类型(l:下部)
# 批注
text(diamond_sample$carat, diamond_sample$volume,
     labels = diamond_sample$X, col = "dimgray",
     cex = 0.7, pos =4)
# 删除异常项
diamond_sample <- diamond_sample %>%
  subset(diamond_sample$X != 9) # 9一定有问题, 1不一定
dim(diamond_sample)
table(diamond_sample$cut)
# 拼写/typo
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
p = ggplot(diamond_sample, aes(x = carat,
                               y = price))
p+geom_point(alpha=0.6) + facet_grid(clarity~.)




# 保存删除
rm(list = ls())
save.image("week7_practice.RData")

