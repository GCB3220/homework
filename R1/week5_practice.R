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
# 3. 中位数平均数相似,
mean(sample_for_die5)
median(sample_for_die5)
# qq图
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
    position_start <- position_start + sample(c(1, -1), 1, prob = c(0.2, 0.8))
  }
  position <- c(position, position_start)
}
hist(position)
# 明显不再是正态分布


# task3
# 成绩正态分布
set.seed(123)
random_numbers <- runif(10000) #均匀分布
scaled_numbers <- (random_numbers * 5) + 81
hist(scaled_numbers)
# 很难说成绩是正态分布,尤其在人数较少时
# 但人数够多,那么应该会接近正态分布


# 保存
save.image(file="week5_practice.RData")
