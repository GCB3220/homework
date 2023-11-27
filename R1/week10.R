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





# 保存
rm(t_is)
save.image(file = "week10.RData")
