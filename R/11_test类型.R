# test类型

# t-test:
#• Samples must be independent (not applicable to paired t-test)
# • Samples must be random
# • Normality of the sample(s)
# For paired t-test, the differences must be normally distributed.
# • Homogeneity of variances (not applicable to one-sample t-test)
# 方差齐性检查:f-test/Bartlett
# f: var.test(x, y, ratio = 1, alternative ...)radio = 1为x=y
# bartlett: bartlett.test(value ～ group, data)group:分组


# rank:
# the deviation from normality is large+can not transform data
# • Wilcoxon signed-rank test - for paired data or one-sample data
# • Mann-Whitney U test - for unpaired data
# Wilcoxon: wilcox.test(x, y, paired = TRUE, ...)
# Wilcoxon, one-sample: wilcox.test(x, mu = 0, ...)
# Mann-Whitney: wilcox.test(x, y, paired = FALSE, ...)




# you will analyse some pieces of data. 
# Identify the right t-test on the following occasions,
# test assumptions, and run the test. 
# After you perform the test, compare the p-value derived by the code 
# with the p-value derived using the pt function. 
# Try one-sided and two-sided tests.
? ToothGrowth
# Task 1: Vitamin C 和 Tooth length
data(ToothGrowth)
tooth_length <- ToothGrowth$len
mean(tooth_length)
summary(ToothGrowth)

# 连续
head(ToothGrowth, 30)
#正态
hist(ToothGrowth$len)
shapiro.test(ToothGrowth$len)
# mean/sd独立
sampling_errors<-c()
sampling_means<-c()
for (replicate in 1:100){
  Tooth_sample<-sample(ToothGrowth$len, 
                       size = length(ToothGrowth), replace = TRUE)
  standard_error<-sd(Tooth_sample)/sqrt(length(Tooth_sample))
  sampling_errors<-c(sampling_errors, standard_error)
  sampling_means<-c(sampling_means, mean(Tooth_sample))
}
plot(sampling_means, sampling_errors)
t.test(len ~ supp, data = ToothGrowth)#supp:分组

tooth_length_VC <- subset(ToothGrowth, supp == "VC")$len
tooth_length_OJ <- subset(ToothGrowth, supp == 'OJ')$len
t.test(tooth_length_OJ, tooth_length_VC)
# p = 0.06 > 0.05, 无法拒绝H0
t.test(tooth_length_VC, mu = 8.5, alternative = "two.sided")
# p < 0.01 HA

# task 2: iris
data(iris)
var.test(iris$Sepal.Length[iris$Species == 'setosa'],
         iris$Sepal.Length[iris$Species == 'versicolor'])
t.test(iris$Sepal.Length[iris$Species == 'setosa'],
       iris$Sepal.Length[iris$Species == 'versicolor'],
       var.equal = T)# 2组variance相同?
# HA

# task 3: blood pressure
blood_pressure <- 
  read.table("blood_pressure.txt", header = T, sep = "\t")
t.test(blood_pressure$bp_before, blood_pressure$bp_after, 
       paired = TRUE)
# HA

# task 4:
wilcox.test(blood_pressure$bp_before, 
            blood_pressure$bp_after, paired = TRUE)
# HA





# problem set
# task 1: 5% siginificant
field_A <- c(10.2, 10.7, 15.5, 10.4, 9.9, 10.0, 16.6, 
             15.1, 15.2, 13.8, 14.1, 11.4, 11.5, 11.0)
field_B <- c(8.1, 8.5, 8.4, 7.3, 8.0, 7.1, 13.9, 12.2, 
             13.4, 11.3, 12.6, 12.6, 12.7, 12.4, 11.3, 12.5)
hist(field_A)
hist(field_B)
# 不能用t-test
wilcox.test(field_A, field_B, alternative = "greater", paired = F)
# H0


# task 2: mouse
mouse <- read.table("mice_weights.txt", head = T,  sep = ",")
summary(mouse)
hist(mouse$before)
hist(mouse$after)
library(ggplot2)
ggplot(data=mouse) +
  geom_line(aes(x=before, col='before'), stat='density') +
  geom_line(aes(x=after,col='after'), stat='density') + 
  theme_classic()
shapiro.test(mouse$before)
var.test(mouse$before, mouse$after)
bartlett.test(mouse$before, mouse$after)
# H0
t.test(mouse$before, mouse$after, 
       paired = TRUE, var.equal=TRUE)

# HA



# 保存
rm(filed_B)
save.image(file = "week11_practice.RData")

