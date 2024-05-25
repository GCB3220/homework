# bootstrap
# task1
df <- read.table("Reporter_assay_4-1-15.txt", header = TRUE, sep = "\t")

library(ggplot2)
ggplot(df, aes(x = Epigenetic_status, y = ave, fill = Transcription_status)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Enhancer Activity by Epigenetic and Transcription Status")

# 计算活性与抑制标记之间的中位数差异
active_median <- median(df$ave[df$Epigenetic_status == "Active"])
repressed_median <- median(df$ave[df$Epigenetic_status == "Repressed"])
median_difference <- active_median - repressed_median

# 打印中位数差异
cat("The median difference in enhancer activity is:", median_difference, "\n")

# 自助法函数
bootstrap_median_diff <- function(data, status_vector, B = 1000) {
  median_diffs <- numeric(B)
  for (i in 1:B) {
    # 从活性和抑制状态中随机抽取相同数量的样本
    sample_active <- sample(data[status_vector == "Active"], replace = TRUE)
    sample_repressed <- sample(data[status_vector == "Repressed"], replace = TRUE)
    
    # 计算当前样本的中位数差异
    median_diffs[i] <- median(sample_active) - median(sample_repressed)
  }
  return(median_diffs)
}

# 使用自助法生成中位数差异的样本
B <- 1000  # 假设我们想要1000个自助样本
bootstrap_diffs <- bootstrap_median_diff(df$ave, df$Epigenetic_status, B)

# 输出第一个自助样本的中位数差异
cat("One bootstrap sample of the median difference is:", bootstrap_diffs[1], "\n")


# Set the number of bootstrap replicates
B <- 10000  # for example, 10,000 bootstrap samples

# Initialize a vector to store the median differences
median_diffs <- numeric(B)

# Bootstrapping process
for (i in 1:B) {
  # Randomly sample with replacement from active enhancers
  active_sample <- sample(df$ave[df$Epigenetic_status == "Active"], replace = TRUE)
  
  # Randomly sample with replacement from repressed enhancers
  repressed_sample <- sample(df$ave[df$Epigenetic_status == "Repressed"], replace = TRUE)
  
  # Calculate the median difference for this bootstrap sample
  median_diffs[i] <- median(active_sample) - median(repressed_sample)
}

# Plot the distribution of median differences
hist(median_diffs, main = "Distribution of Median Differences", xlab = "Median Difference")


# Load the data
movie_data <- read.table("movie_data.txt", header = TRUE)

# Plot the data
barplot(movie_data$count, main = "Popularity of Movie Genres Among University Students", xlab = "Genre", ylab = "Number of Students")

# Total number of responses
total_responses <- 267

# Number of students who preferred comedy
comedy_responses <- 73

# Generate a bootstrap sample for the comedy genre
comedy_bootstrap <- sample(x = c(rep(1, comedy_responses), rep(0, total_responses - comedy_responses)), size = total_responses, replace = TRUE)
