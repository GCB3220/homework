# t-test

# 1. Data is continuous and randomly-selected. 
# See lecture on sampling:
# 2. The sample is normally distributed. 
# See lecture on sampling distributions
# shapiro.test, hist
# 3. The mean and standard error are independent. 
# Nearly always true, but could test by simulation





# task1
temp <- read.csv("OrionTemp.csv")
head(temp)
summary(temp)
mysample <- sample(temp$Temperature, size = 10, replace = TRUE)
t.test(mysample, mu = 37, alternative = "two.sided")
# mean = 37.047
# p-value = 0.2237
# not reject H0
results <- data.frame(
  Sample_Mean = numeric(100),
  P_Value = numeric(100),
  Significant = character(100)
)
for (i in 1:100){
  mysample <- sample(temp$Temperature, size = 20, replace = TRUE)
  t_result <- 
    t.test(mysample, mu = 37, alternative = "two.sided")
  results$Sample_Mean[i] <- mean(mysample)
  results$P_Value[i] <- t_result$p.value
  results$Significant[i] <- 
    ifelse(t_result$p.value < 0.05, "Yes", "No")
}
# H0
# not depend on sample size
library(ggplot2)
ggplot(results, mapping = aes(x = Significant))+geom_bar(width = 0.1)
test_size <- c(20, 50, 100, 200, 300, 400)
test_data <- c()
for (i in test_size){
  num <- 0
  for (j in 1:100){
    my_sample <- sample(temp, size = i, replace = T)
    result <- t.test(my_sample)
    if (result$p.value <= 0.05){ 
      num <- num+1
      }
  }
  test_data <- c(test_data, num)
}
barplot(test_data)





# problem set
# task1
barley_data <- read.table("barley.txt")
barley<-scan("barley.txt")
# 1.独立随机取样
# 2.正态?
# 3.平均值和标准误差是独立的
hist(barley_data$V1, xlab = "Barley weights (g)", main = "")
summary(barley_data)
mysample <- sample(barley_data$V1, size = 10, replace = T)
t.test(mysample, mu = 50, alternative = "greater")
t.test(mysample, mu = 50, alternative = "two.sided")
t.test(barley_data$V1, mu = 50, alternative = "greater")
t_results <- data.frame(
  Sample_Mean = numeric(100),
  P_Value = numeric(100),
  Significant = character(100)
)
for (i in 1:100){
  mysample <- sample(barley_data$V1, size = 10, replace = T)
  t_result <- t.test(mysample, mu = 50, alternative = "greater")
  t_results$Sample_Mean[i] <- mean(mysample)
  t_results$P_Value[i] <- t_result$p.value
  t_results$Significant[i] <- 
    ifelse(t_result$p.value < 0.05, "Yes", "No")
}

# 正态
shapiro.test(barley_data$V1)

# 平均值和标准误差是独立的
sampling_errors<-vector()
sampling_means<-vector()
for (replicate in 1:100){
  barley_sample<-sample(barley_data$V1, 
                        size = length(barley_data$V1), 
                        replace = TRUE)
  standard_error<-sd(barley_sample)/sqrt(length(barley_sample))
  sampling_errors<-c(sampling_errors, standard_error)
  sampling_means<-c(sampling_means, mean(barley_sample))
}
plot(sampling_means, sampling_errors, 
     xlab = "Sample mean", ylab = "Standard error")
lmfit<-lm(sampling_errors~sampling_means)
abline(lmfit, col = 'red')
summary(lmfit)

# t-test sample大小
sig_results<-vector()
for (sample_size in 5:50){
  found_sigs<-0
  for (replicate in 1:100){
    barley_sample<-sample(barley_data$V1, 
                          size = sample_size, 
                          replace = FALSE)
    p_value<-t.test(barley_sample, mu = 50)$p.value
    if (p_value <= 0.05){
      found_sigs = found_sigs + 1
    }
  }
  sig_results<-c(sig_results, found_sigs)
}
plot(sig_results, type = 'l', 
     ylab = "No. significant results/100", 
     xlab = "Sample size")
abline(h = 95, col = 'red')



# 保存
rm(temp)
save.image(file = "week10_practice.RData")