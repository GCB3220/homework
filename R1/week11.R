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

t.test(len ~ supp, data = ToothGrowth)

tooth_length_VC <- subset(ToothGrowth, supp == "VC")$len
tooth_length_OJ <- subset(ToothGrowth, supp == 'OJ')$len
t.test(tooth_length_OJ, tooth_length_VC)
# p = 0.06 > 0.05, 无法拒绝H0
t.test(tooth_length_VC, mu = 8.5, alternative = "two.sided")
# p < 0.01 HA

# task 2: iris
data(iris)
t.test(iris$Sepal.Length[iris$Species == 'setosa'],
       iris$Sepal.Length[iris$Species == 'versicolor'],
       var.equal = FALSE)
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


# 保存
rm(theoretical_mean)
save.image(file = "week11.RData")
