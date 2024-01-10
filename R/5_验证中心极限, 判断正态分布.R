# 验证中心极限, 判断正态分布

# SEM:标准差是单次抽样得到的，
# 用单次抽样得到的标准差可以估计多次抽样才能得到的标准误差
# 暨标准误差有两种算法, 一是样本平均值的标准差, 二是样本标准差/样本大小




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
plot(5:100, sd_for_all, xlab = "sample")


# task2
# 掷骰子1000次并观其结果
sample_for_die <- sample(1:6, 1000, replace = TRUE)
remove(smaple_for_die)
hist(sample_for_die, breaks = 0.5:6.5) # 默认步长为1
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
  sample_for_wingspan <- sample(wingspan, 20)
  mean_for_wingspan <- c(mean_for_wingspan, mean(sample_for_wingspan))
}
hist(mean_for_wingspan)

save.image(file = "week5.RData")







# problem note 

# task1
# 掷骰子
sample_for_die <- sample(1:6, 1000, replace=TRUE)
sample_for_die2 <- sample(1:6, 1000, replace=TRUE)
sample_for_die2 <- sample_for_die2+sample_for_die
hist(sample_for_die2, breaks = 1.5:12.5)
# 解释:
# 1. 相当于两组1:6随机抽样, 抽中的数的mean会接近3,所以相加会在6:8之间多
# 2. 5个:
sample_for_die5 <- sample(1:6, 1000, replace=TRUE)+
  sample(1:6, 1000, replace=TRUE)+sample(1:6, 1000, replace=TRUE)+
  sample(1:6, 1000, replace=TRUE)+sample(1:6, 1000, replace=TRUE)
hist(sample_for_die5)
# 辨别正态分布
# 直接根据分布特点
dicerolls <- sample(1:6, 1000, replace=TRUE)+ 
  sample(1:6, 1000, replace=TRUE)+sample(1:6, 1000, replace=TRUE)
minus1sd = mean(dicerolls)-sd(dicerolls)
plus1sd = mean(dicerolls)+sd(dicerolls)
sum(dicerolls>minus1sd & dicerolls<plus1sd)/10
# 66.7 -> 接近68
# sd变为2 -> 接近95
# 3. 中位数平均数相似,
mean(sample_for_die5)
median(sample_for_die5)
# qq图 重合则为正态
qqnorm(sample_for_die5)
qqline(sample_for_die5)
# test: Shapiro-Wilk Test, Anderson-Darling....
shapiro.test(sample_for_die5)


# task2 
# bean machine/豆子机,当豆子下落时,它有50%的几率往左/右,一共8个节点
position <- c()
for (i in 1:1000){
  position_start <- 0
  for (layer in 1:8){
    # +-1中选一个
    position_start <- position_start + sample(c(1, -1), 1)
  }
  position <- c(position, position_start)
}
hist(position)
# 概率改变后
position <- c()
for (i in 1:1000){
  position_start <- 0
  for (layer in 1:8){
    # +-1中选一个 prob->80%
    position_start <-
      position_start + sample(c(1, -1), 1, prob = c(0.2, 0.8))
  }
  position <- c(position, position_start)
}
hist(position)
# 明显不再是正态分布
# 但次数够多, 依然正态


# task3
# 成绩正态分布
set.seed(123)
random_numbers <- runif(10000) #均匀分布
scaled_numbers <- (random_numbers * 5) + 81
hist(scaled_numbers)
# 很难说成绩是正态分布,尤其在人数较少时
# 但人数够多,那么应该会接近正态分布
# 可以将问卷每个试题分别建模, 比如每个试题正确概率为60%, 错误为40%
# 利用中心极限, 依然正态分布
# 但有几个前提: 各个学生概率一致, 样本够大...
# 题目难度, 学生水平...都会影响


# 保存
save.image(file="week5_practice.RData")
