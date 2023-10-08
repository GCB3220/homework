# task1
# 读取csv至dataframe
df <- read.csv("Chicago2013.csv")
# 计数国家
usa_count <- sum(df$Country == "USA")
num_different_countries <- length(unique(df$Country))
# 画finishtime草图
time_finish <- df$Time
hist(time_finish, main="Histogram of finish time",
     xlab="finish time", ylab="number")
# 随机抽十人
random_10 <- sample(df$Name, size=10)
# random_df <- data.frame(name=random_10, finish=df$finish)


# task2
# 创建一个100人小组
men_height <- rnorm(45, mean=172, sd=7)
women_height <- rnorm(55, mean=158.5, sd=6)
# 验证
print(mean(men_height))
print(sd(men_height))
# 画boxplot
boxplot(men_height, main="men height", col="green")
# 最大,最小,比xx大
print(max(men_height))
print(min(men_height))
print(sum(men_height>175))
# mean, median, quantile
print(median(men_height))
print(quantile(men_height))


# task3
# 26人随机分配生日
birthday_group <- sample(1:365, 26, replace=TRUE)
# 检查共享生日
length(birthday_group) == length(unique(birthday_group))
# 预测任意26人有共享生日的概率
shared_birthdays_count <- 0
for (i in 1:10000) {
  birthdays <- sample(1:365, 26, replace = TRUE)
  if (length(birthdays) != length(unique(birthdays))) {
    shared_birthdays_count <- shared_birthdays_count + 1
  }
}
probability_shared_birthday <- shared_birthdays_count / 10000
# n从1~50共享生日的概率预测与画图
probability_vector <- c()
for (n in 1:50){
  shared_birthdays_count <- 0
  for (i in 1:10000) {
    birthdays <- sample(1:365, n, replace = TRUE)
    if (length(birthdays) != length(unique(birthdays))) {
      shared_birthdays_count <- shared_birthdays_count + 1
    }
  }
  probability_vector <- c(probability_vector, 
                          shared_birthdays_count/10000)
}
dotchart(1:50, label=probability_vector)


# task4
# sample
ALT_data <- c(33.45, 24.67, 24.16, 21.27, 26.86, 27.38, 27.91, 
              26.15, 31.63, 28.12)
# mean/sd
mean_ALT <- mean(ALT_data)
sd_ALT <- sd(ALT_data)
# 取样
sample_ALT <- rnorm(10000, mean=mean_ALT, sd=sd_ALT)
# 根据条件猜概率
# if (40.2 %in% sample_ALT)
# if (any(sample_ALT > 33))
probability_in_condition <- 0
for (i in 1:10000) {
  sample_ALT <- rnorm(100, mean = mean_ALT, sd = sd_ALT)
  if (any(sample_ALT > 33)) {
    probability_in_condition <- probability_in_condition + 1
  }
}




# final
# 保存工作环境
save.image(file = "week2_practice.RData")

