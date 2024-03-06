# task1:单样本统计效益
# 1. 模拟实验p_value
p_values <- c()
for (i in 1:10000){
  height_sample <- rnorm(10, 178, 10)
  p_value <- t.test(height_sample, mu = 175)$p.value
  p_values <- c(p_values, p_value)
}
mean(p_values>0.05)
# 86%大于0.05->86%的实验中无显著差异，14%H1成立
# 功效将为 1 - 0.86 = 0.14，正确检测真实差异的概率为 14%。

# 2. 将sample_size扩大到50
p_values <- c()
for (i in 1:10000){
  height_sample <- rnorm(50, 178, 10)
  p_value <- t.test(height_sample, mu = 175)$p.value
  p_values <- c(p_values, p_value)
}
mean(p_values>0.05)
# 45%大于0.05
# 功效变大

# 3.power.t.test应用
sample_size <- seq(5, 100, by = 5)
powers <- c()
for (i in sample_size) {
  power <- power.t.test(i, 3, 10)$power
  powers <- c(powers, power)
}
plot(sample_size, powers, type = "b") #b:both


# task2: 选择样本大小
# 1. 类型2错误概率/beta
p_values <- c()
for (i in 1:10000) {
  placebo_weights <- rnorm(10, mean = 130, sd = 30)
  drug_weights <- rnorm(10, mean = 130*0.9, sd = 30)
  p_value <- t.test(placebo_weights, drug_weights, 
                    alternative = "greater")$p.value
  p_values <- c(p_values, p_value)
}
mean(p_values>0.05)
# 75%无差异，power为 1-0.75=25%

# 2. 改进样本大小
p_values <- c()
for (i in 1:10000) {
  placebo_weights <- rnorm(70, mean = 130, sd = 30)
  drug_weights <- rnorm(70, mean = 130*0.9, sd = 30)
  p_value <- t.test(placebo_weights, drug_weights, 
                    alternative = "greater")$p.value
  p_values <- c(p_values, p_value)
}
mean(p_values>0.05)
# power = 82%

# 3. 改变策略，所有人服药
power.t.test(90, 13, 30)
# 82% -> 90人

# 4. 样本量与p值power的关系
estimate_size <- function(power, p) {
  size <- 10
  while (power.t.test(size, 13, 30, sig.level = p)$power < power) {
    size <- size+10
  }
  return(size)
}
size_needed <- c()
p_seq <- c(0.01, 0.02, 0.03, 0.04, 0.05)
for (i in p_seq) {
  size_needed <- c(size_needed, estimate_size(0.8, i))
}
plot(p_seq, size_needed)
power_seq <- c(0.5, 0.6, 0.7, 0.8, 0.9)
for (i in power_seq) {
  size_needed <- c(size_needed, estimate_size(i, 0.05))
}
plot(power_seq, size_needed)



# problem set
# task1: 咖啡与成绩
power.t.test(50, 0.25, 0.42)

# task2: 影响power因素及其之间关系
power.t.test(20, 0.4, 0.5)
# 0.69
power.t.test(20, 0.4, 0.5, sig.level = 0.1)
# 0.79
power.t.test(10, 0.4, 0.5)
# 0.39
power.t.test(20, 0.8, 0.5)
# 0.99
powers <- c()
p_seq <- seq(0.01, 0.1, by = 0.01)
for (i in p_seq) {
  powers <- c(powers, power.t.test(20, 0.4, 0.5, sig.level = i)$power)
}
plot(p_seq, powers)

size_seq <- seq(10, 100, by = 10)
for (i in size_seq) {
  powers <- c(powers, power.t.test(i, 0.4, 0.5)$power)
}
plot(size_seq, powers)

effect_seq <- seq(0.1, 1, by = 0.1)
for (i in effect_seq) {
  powers <- c(powers, power.t.test(20, i, 0.5)$power)
}
plot(effect_seq, powers)

# task3: 样本大小和p值
sample_1 <- rnorm(5, 10, 5)
sample_2 <- rnorm(5, 11, 5)
t.test(sample_1, sample_2)
# 无差异
sample_1 <- rnorm(500, 10, 5)
sample_2 <- rnorm(500, 11, 5)
t.test(sample_1, sample_2)
# 有差异
size_seq <- seq(10, 500, by = 10)
p_values <- c()
for (i in size_seq) {
  sample_1 <- rnorm(i, 10, 5)
  sample_2 <- rnorm(i, 11, 5)
  p_values <- c(p_values, t.test(sample_1, sample_2)$p.value)
}
plot(size_seq, p_values)
