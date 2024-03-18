# task1: chi-square模拟
# 拟合度检查
Poll_seasons <- data.frame(Spring = 40, Summer = 30, Autumn = 18, Winter = 28)
equal_preferences <- sum(Poll_seasons) * 0.25
# 模拟计算
calculate_chi_square <- function(observed, expected) {
  chi_square <- sum((observed - expected)^2 / expected)
  return(chi_square)
}
# 重复
chi_square_values <- numeric(10000)
for (i in 1:10000) {
  simulated_data <- table(sample(c("Spring", "Summer", "Autumn", "Winter"), size = 116, replace = TRUE, prob = c(0.25, 0.25, 0.25, 0.25)))
  chi_square_values[i] <- calculate_chi_square(simulated_data, equal_preferences)
}
# 图
plot(density(chi_square_values))
# 模拟p-value
observed_chi_square <- calculate_chi_square(as.numeric(Poll_seasons), equal_preferences)
p_value <- mean(chi_square_values >= observed_chi_square)
# 模拟与chisp.test
observed_data <- as.vector(unlist(Poll_seasons))
chisq_result <- chisq.test(observed_data, p = rep(0.25, length(observed_data)))
chisq_result$p.value

# task2: 不同自由度的卡方值
df <- c(2, 4, 6, 8)  
num_values <- 10000  

chi_square_values <- lapply(df, function(d) {
  rchisq(num_values, df = d)
})

par(mfrow = c(2, 2))  
for (i in seq_along(df)) {
  hist(chi_square_values[[i]], freq = FALSE, main = paste("Chi-square (df =", df[i], ")"), xlab = "Value", col = "lightblue")
  curve(dchisq(x, df = df[i]), add = TRUE, col = "red", lwd = 2)
}

# task3: 可视化
season_preference <- c("Spring", "Summer", "Autumn", "Winter")
reported_allergy <- c("Yes", "No", "Yes", "No")
data <- data.frame(Season_Preference = season_preference, Reported_Allergy = reported_allergy)

barplot(table(data$Season_Preference, data$Reported_Allergy),
        beside = TRUE, legend = TRUE,
        main = "Bar Plot of Season Preference vs Reported Allergy",
        xlab = "Season Preference", ylab = "Frequency",
        col = c("lightblue", "lightgreen"),
        names.arg = season_preference)

library(vcd)
balloonplot(table(data$Season_Preference, data$Reported_Allergy),
            main = "Balloon Plot of Season Preference vs Reported Allergy",
            xlab = "Season Preference", ylab = "Reported Allergy")

mosaicplot(table(data$Season_Preference, data$Reported_Allergy),
           main = "Mosaic Plot of Season Preference vs Reported Allergy",
           xlab = "Season Preference", ylab = "Reported Allergy",
           color = TRUE)

chi_square_result <- chisq.test(table(data$Season_Preference, data$Reported_Allergy))
print(chi_square_result)

# task4: fisher.test()
survival_data <- matrix(c(10, 20, 15, 25), nrow = 2, byrow = TRUE)
colnames(survival_data) <- c("Survived", "Died")
rownames(survival_data) <- c("GeneX KO", "Control")

chi_square_result_no_correction <- chisq.test(survival_data, correct = FALSE)
print(chi_square_result_no_correction)

chi_square_result_with_correction <- chisq.test(survival_data, correct = TRUE)
print(chi_square_result_with_correction)

fisher_test_result <- fisher.test(survival_data)
print(fisher_test_result)





# probelm set
# 模拟
cream_favourite <- data.frame(Mint = 40, Vanilla = 32, Chocolate = 48, 
                              Lemon = 57, Orange = 23)
equal_preference <- sum(cream_favourite)*0.25

calculate_chi_square <- function(observed, expected) {
  chi_square <- sum((observed - expected)^2 / expected)
  return(chi_square)
}

chi_square_values <- numeric(1000)
for (i in 1000) {
    simulated_data <- table(sample(c("Mint", "Vanilla", "Chocolate", "Lemon", "Orange"), 
                                   size = 116, replace = TRUE, prob = c(0.2, 0.2, 0.2, 0.2, 0.2)))
    chi_square_values[i] <- calculate_chi_square(simulated_data, equal_preference)
}
plot(density(chi_square_values))
p_value <- mean(chi_square_values >= as.vector(cream_favourite), equal_preference)
chisq.test(cream_favourite)

hist(rchisq(1000, 4))

# 3 way
contingency_table <- matrix(c(40, 34, 20, 25,9, 7, 15, 20), 
                            nrow = 2, byrow = TRUE,
                            dimnames = list(Condition = c("Alive", "Dead"),
                                            Treatment = c("WT_Male", "WT_Female", "KO_Male", "KO_Female")))
chisq.test(contingency_table)
library(ggplot2)
dot_plot <- ggplot(contingency_table, aes(x = Treatment, y = Count, fill = Condition)) +
  geom_point(position = position_dodge(width = 0.5), size = 3, shape = 21) +
  geom_errorbar(aes(ymin = Count - 1, ymax = Count + 1), position = position_dodge(width = 0.5), width = 0.2)
dot_plot
