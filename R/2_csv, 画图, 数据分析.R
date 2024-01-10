# csv, 画图, 数据分析

# sum, hist, plot, grouop_by, rnorm, summarise, mean, quantile, sample, 
# pnorm, boxplot



# practice
# task1
# 读取csv至data frame
chicago <- read.csv("Chicago2013.csv")
# 计数国家
usa_count <- sum(chicago$Country == "USA")
num_different_countries <- unique(chicago$Country)
# 或者
library(dplyr)
country_counts <- chicago %>%
  group_by(Country) %>% # 分组
  summarise(count = n()) # 与group by合用, n()表示观测值数量
# 画finish_time草图
time_finish <- chicago$Time
hist(time_finish, main="Histogram of finish time",
     xlab="finish time", ylab="number")
# 随机抽十人
random_10 <- chicago[sample(nrow(chicago), 10), ]
hist(random_10$Time, main="Histogram of finish time", 
     xlab="finish time", ylab="number", col = "green")
# 其他: random_df <- data.frame(name=random_10, finish=df$finish)


# task2
# 创建一个100人小组
men_height <- rnorm(45, mean=172, sd=7) # 随机正态分布
women_height <- rnorm(55, mean=158.5, sd=6)
# 验证
print(mean(men_height))
print(sd(men_height))
# 画box-plot
boxplot(men_height, main="men height", col="green")
# 最大,最小,比xx大
print(max(men_height))
print(min(men_height))
print(sum(men_height>175))
# mean, median, quantile:四分位数
print(median(men_height))
print(quantile(men_height)[3])
# Q3
quantile(men_height, 0.75)


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
  for (i in 1:1000) {
    birthdays <- sample(1:365, n, replace = TRUE)
    if (length(birthdays) != length(unique(birthdays))) {
      shared_birthdays_count <- shared_birthdays_count + 1
    }
  }
  probability_vector <- c(probability_vector, 
                          shared_birthdays_count/10000)
}
# dotchart(1:50, label=probability_vector)
plot(1:50, probability_vector, type = "l", pch = 16, col = "blue",
     xlab = "Number of Students in the Group",
     ylab = "Probability of Shared Birthday",
     main = "Probability of Shared Birthday in a Group")
# type=b: 点加线, pch=16: 代表一个实心圆
# “p”：此选项仅绘制没有任何连接线的点。每个数据点都由绘图上的标记表示
# “l”：此选项仅绘制连接数据点的线。每个数据点不会有单独的标记
# “b”：此选项绘制点和线。它用线连接数据点，并在每个数据点放置标记
# “o”：与“b”类似，此选项同时绘制点和线，但线是在标记上绘制的，“过度绘制”
# “c”：此选项仅绘制通过数据点中心的线，而不绘制从这些点延伸的任何垂直线
# “h”：此选项与“c”类似，但它包括从每个数据点向下延伸到 x 轴的垂直线
# “n”：此选项忽略点和线。它会导致一个空的情节。
# hollow cycle: pch1


# task4
# sample
ALT_data <- c(33.45, 24.67, 24.16, 21.27, 26.86, 27.38, 27.91, 
              26.15, 31.63, 28.12)
# mean/sd
mean_ALT <- mean(ALT_data)
sd_ALT <- sd(ALT_data)
# 取样(样本代表全体)
sample_ALT <- rnorm(10000, mean=mean_ALT, sd=sd_ALT)
# 根据条件猜概率
# gpt:
pnorm(40.2, mean = mean_ALT, sd = sd_ALT) # 正态分布的累积分布函数 (CDF)
1 - pnorm(33, mean = mean_ALT, sd = sd_ALT) # 返回随机变量小于或等于该值的概率
# lower.tail = false: 变为大于
# 取范围
diff(pnorm(c(22, 25), mean = mean_ALT, sd = sd_ALT)) # 两个概率差异
diff(pnorm(c(27, 31), mean = mean_ALT, sd = sd_ALT))
# diff:两者差值
# 40%~65%之间, 可以用quantile
quantile_values <- quantile(ALT_data, c(0.4, 0.65))
prob_within_quantiles <- diff(pnorm(quantile_values, mean_ALT, sd_ALT))
# 小于99.995%
value_less_than_99_995 <- qnorm(0.99995, mean_ALT, sd_ALT)
# sample 模拟
set.seed(123)  # Set seed for reproducibility
simulated_values <- rnorm(10000, mean_ALT, sd_ALT)
simulated_prob_27_31 <- mean(simulated_values >= 27 & simulated_values <= 31)
# sum计算所有true, mean得概率


# 变体
sum(rnorm(10000, mean = mean_ALT, sd = sd_ALT) > 40.2) / 10000
sum(rnorm(10000, mean = mean_ALT, sd = sd_ALT) > 33) / 10000

probability_22_25 <- 
  sum(rnorm(10000, mean = mean_ALT, sd = sd_ALT) > 22 
      & rnorm(10000, mean = mean_ALT, sd = sd_ALT) < 25) / 10000

probability_27_31 <- 
  sum(rnorm(10000, mean = mean_ALT, sd = sd_ALT) > 27 
      & rnorm(10000, mean = mean_ALT, sd = sd_ALT) < 31) / 10000

quantile_values <- quantile(alt_values, c(0.4, 0.65))
probability_within_quantiles <- 
  sum(rnorm(10000, mean = mean_ALT, sd = sd_ALT) > quantile_values[1] & 
        rnorm(10000, mean = mean_ALT, sd = sd_ALT) < 
        quantile_values[2]) / 10000

value_less_than_99_995 <- 
  quantile(rnorm(10000, mean = mean_ALT, sd = sd_ALT), 0.99995)


# 清空
rm(list = ls())




# problem note
# task1
# 100名学生查看成绩
# 平均86,标准差5.0,绘图
sample_for_students <- rnorm(100, mean=86, sd=5.0)
hist(sample_for_students, main="histogram for students grade", xlab = 
       "grade", ylab="people", col="red")
abline(v = c(81, 91, 76, 96), col = c("red", "red", "green", "green"), lty = 3)
# v:垂直, lty=2:虚线
# 成绩大于91/小于86
higher_than_91 <- sum(sample_for_students>91)
lower_than_86 <- sum(sample_for_students<86)
# 或
sum(sample_for_students<81 | sample_for_students>91)
# 问题:???
# 太随机? 分数超100
# 用rnorm()的话最高分会超100
other_class = c(36, rep(86,49), rep(87,50)) # rep:重复
mean(other_class)
marks <- pmax(0, pmin(rnorm(100, mean = 86, sd = 5.0), 100))
# pmax:对比向量中各个向及输入数, 取最大值(防止0)


# task2
# 考试策略
# 20道4项选择题
question_ABCD <- sample(1:4, 20, replace=TRUE)
# 全选A vs 全随机
A_pass <- 0
random_pass <-0
for (i in 1:1000){
  question_ABCD <- sample(1:4, 20, replace=TRUE)
  all_in_A <- sum(question_ABCD==1)
  random_answer <- sample(1:4, 20, replace=TRUE)
  random_score <- sum(question_ABCD==random_answer)
  if (all_in_A>10){
    A_pass <- A_pass+1
  }
  if (random_score>10) random_pass <- random_pass+1
}
A_pass > random_pass

# ABCD频率一致
question_ABCD_same <- sample(1:4, 20, replace = TRUE, 
                             prob = c(1/4, 1/4, 1/4, 1/4))


for (i in 1:1000){
  question_ABCD_same <- sample(1:4, 20, replace = TRUE, 
                               prob = c(1/4, 1/4, 1/4, 1/4))
  all_in_A <- sum(question_ABCD_same==1)
  random_answer <- sample(1:4, 20, replace=TRUE, prob = c(1/4, 1/4, 1/4, 1/4))
  random_score <- sum(question_ABCD_same==random_answer)
  if (all_in_A>10){
    A_pass <- A_pass+1
  }
  if (random_score>10) random_pass <- random_pass+1
}
A_pass > random_pass


