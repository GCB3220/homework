# 模拟

# pnorm->输入z-score得到累积概率
# qnorm: pnorm反函数


# 例子实现
raw_scores <- c(17, 17.5, 16, 16.4, 18.9, 18.3, 18.6, 20, 15.5, 18.1)
normative_scores <- round(rank(raw_scores) / length(raw_scores) * 100-5)
# Q1 26名学生
mean_26 <- stimulate_class_means(26, 100)
sum(mean_26<40)
# 学生数+模拟数
stimulate_class_means <- function(num_students, max_score) {
  normative_scores_class <- 
    matrix(runif(num_students * 10000, 0, max_score), 
           ncol = num_students)
  mean_normative_scores <- rowMeans(normative_scores_class)
  return(mean_normative_scores)
}

means_5 <- 
  stimulate_class_means(5, 100)
sum(means_5 < 40)

plot(density(means_5), main = "Distribution of Class Means",
     xlab = "Mean Normative Score", col = "red")
hist(means_5, col = "skyblue") 

# Q2 80最大
means_80 <- 
  stimulate_class_means(26, 80)
sum(means_80 > mean_26)

hist(means_80)

# Q3 两组正态后成绩对比
leonie_raw_scores <- c(64, 63, 62, 59)
sheldon_raw_scores <- c(70, 63, 61, 56)
leonie_normative_scores <- stim_group_mean(leonie_raw_scores)
mean(leonie_normative_scores)
sheldon_normative_scores <- stim_group_mean(sheldon_raw_scores)
mean(sheldon_normative_scores)

stim_group_mean <- function (scores){
  stim_whole <- rnorm(1000, 50, sd = 10)
  sample_mean <- c()
  for (i in scores) {
    sample_mean <- c(sample_mean, 
                     sum(stim_whole <= i)/10)
  }
  return(sample_mean)
}

# Q4: Q2->正态分布
hist(rnorm(1000, 40, 8))
stim_norm <- function(num, score, sd){
  score_matrix <- matrix(rnorm(num*10000, score, sd), nrow=num)
}





# 保存/删除
rm(list = ls())
save.image(file = "week8.RData")
