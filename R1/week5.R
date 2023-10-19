# task1
# 5:100样本大小, 求sd变化
population <- rnorm(1e6,100,5)
sd_for_all <- c()
for (sample_size in 5:100){
  mean_for_test <- c()
  sd_for_test <- 0
  # 每个大小1000次实验
  for (i in 1:1000){
    sample_for_test <- sample(population, sample_size)
    mean_for_test <- c(mean_for_test, mean(sample_for_test))
  }
  # 得出各个大小sd
  sd_for_test <- sd(mean_for_test)
  sd_for_all <- c(sd_for_all, sd_for_test)
}
plot(5:100, sd_for_all)


# task2
# 掷骰子1000次并观其结果
sample_for_die <- sample(1:6, 1000, replace = TRUE)
remove(smaple_for_die)
hist(sample_for_die, breaks = 0.5:6.5)
sample_for_die <- sample(1:6, 1000, replace=TRUE)+
  sample(1:6, 100, replace=TRUE)
hist(sample_for_die)


# task3
# 读dragon.csv取样本验证中心极限
df <- read.csv("dragons.csv")
wingspan <- df$wingspan
hist(wingspan)
mean_for_wingspan <- c()
for (i in 1:1000){
  sample_for_wingspan <- sample(wingspan, 10)
  mean_for_wingspan <- c(mean_for_wingspan, mean(sample_for_wingspan))
}
hist(mean_for_wingspan)

save.image(file = "week5.RData")
