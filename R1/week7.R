# task1
# 读取文件+探索
row_data_WNV <- read.csv("week_7_WNV_mosquito_test_results.csv")
head(row_data_WNV)
# 行数
nrow(row_data_WNV)
# 提供属性
attributes(row_data_WNV)
summary(row_data_WNV)
# 频率表是一种通过计算变量中每个唯一类别或级别的出现次数
# 来汇总分类数据
table(row_data_WNV$YEAR)
# 对象的结构和数据类型
str(row_data_WNV)
class(row_data_WNV$TEST.DATE)
# 长格式数据高而窄，每行通常代表一个观察结果，
# 每个变量都与一个标识符或类别相关联
# 宽格式数据宽，每行代表一个不同的实体或案例，变量存储为单独的列。
# 所以为长:long form
# 修改variable name library(dplyr)
library(tidyverse)
row_data_WNV <- row_data_WNV %>% rename("YEAR" = "SEASON.YEAR")
# colname 必须全上
colnames(row_data_WNV) <- "YEAR"
# 检查missing value
anyNA(row_data_WNV)
# 检查重复行+修订数据
duplicate_row <- duplicated(row_data_WNV)
update_data_WNV <- subset(row_data_WNV, !duplicate_row)
# 去除"" (!=NA)
# 检查->所以""替换为FALSE(逻辑数据框)
empty_block <- update_data_WNV == "" 
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
wnv_plot <- ggplot(data = update_data_WNV) +
  theme_classic()
# 添加boxplot
wnv_plot +
  geom_boxplot(mapping = aes(x = as.factor(YEAR),
                             y = NUMBER.OF.MOSQUITOES))
# 
wnv_plot +
  geom_boxplot(mapping = aes(x = round(LATITUDE, 3),
                             y = NUMBER.OF.MOSQUITOES,
                             group = round(LATITUDE, 3)),
               position = "identity",
               outlier.shape = NA) +
  scale_x_continuous()
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
anyNA(pgp3)
sum(duplicated(pgp3))
pgp3[which(duplicated(pgp3)),]
pgp3[which(pgp3$SampleID %in% c(2,7,46,201)),]
# 长形式,not tidy
pgp3 <- pgp3 %>%
  .[-which(duplicated(.)),] %>%
  spread(key = measured, value = value)#长变宽
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
# 修改性别标识
pgp3$sex[which(pgp3$sex == 1)] <- "Male"
pgp3$sex[which(pgp3$sex == 2)] <- "Female"
# ""替换为na
pgp3$age.f[pgp3$age.f == ""] <- NA
# 重组织
pgp2 <- pgp3 %>%
  mutate_at(.vars = c(1,2,5), .funs = as.factor) %>%
  mutate_at(.vars = c(3,4), .funs = as.numeric) %>%
  relocate(1,5,2,4,3) %>%
  # gather:变长数据:time.point代表之前变量的列, od代表值列
  gather(key = "Time.point", value = "OD", c(4,5)) %>%
  drop_na(c(2,3)) %>%
  mutate(Time.point = factor(Time.point, 
                             levels = c("elisa.pre.od", "elisa.od"), 
                             ordered = T)) %>%
  droplevels()
str(pgp3)
# 绘图
ggplot(data = pgp3, aes(x = age.f,
                        y = OD,
                        fill = Time.point)) +
  geom_boxplot(color = "black") +
  theme_classic() +
  scale_fill_manual(labels = c("elisa.pre.od", "elisa.od"),
                    name = "Measurement",
                    values = c("#ADD8E6", "#FF6347"),
                    breaks = c("elisa.pre.od", "elisa.od")) +
  theme(legend.position = "right") +
  guides(color = guide_legend(override.aes = list(size = 3) ) )
15






# 保存/删除无用
remove(pgp2)
save.image(file = "week7.RData")
