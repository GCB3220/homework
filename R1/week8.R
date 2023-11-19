# 例子实现
raw_scores <- c(17, 17.5, 16, 16.4, 18.9, 18.3, 18.6, 20, 15.5, 18.1)
normative_scores <- round(rank(raw_scores) / length(raw_scores) * 100-5)
# Q1 26名学生
# 学生数+模拟数
simulate_class_means <- function(num_students, max_score) {
  normative_scores_class <- 
    matrix(runif(num_students * 10000, 0, max_score), 
           ncol = num_students)
  mean_normative_scores <- rowMeans(normative_scores_class)
  return(mean_normative_scores)
}
means_100 <- 
  simulate_class_means(5, 100)
mean(means_100 < 40)

plot(density(means_100), main = "Distribution of Class Means",
     xlab = "Mean Normative Score", col = "red")
hist(means_100, col = "skyblue") 

# Q2 80最大
means_80 <- 
  simulate_class_means(26, 80)
mean(means_80 > means_100)

hist(means_80)
# Q3 64 50 10





# 保存/删除
rm(simulated_means)
save.image(file = "week8.RData")
