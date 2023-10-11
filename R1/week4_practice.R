# task1
population <- rnorm(1e6,100,5)
popmean <- round(mean(population),1)
# 随机抽5个
sample_5 <- sample(population, 5)
sample_5_mean <- round(mean(sample_5), 1)
sample_5_sd <- round(sd(sample_5), 1)
# 抽取1000个大小为5的样本并绘制mean, sd变化
mean_for_1000 <- c()
sd_for_1000 <- c()
for (i in 1: 1000){
  sample_5 <- sample(population, 5)
  mean_for_1000 <- c(mean_for_1000, round(mean(sample_5), 1))
  sd_for_1000 <- c(sd_for_1000, round(sd(sample_5), 1))
}
hist(mean_for_1000)
hist(sd_for_1000)
# 样本变大 -> 正态分布

# task 2
# 样本偏差: 早餐健康评判标准, 其他因素影响

# 保存
save.image(file = "week4_practice.RData")
