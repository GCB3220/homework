# task1: 药实验的三种情况
drug_trial <- read.csv("drug_trial.csv")
head(drug_trial)
summary(drug_trial)
str(drug_trial)

# H0：三组间无差异
# H1：存在差异

library(tidyr)
placebo <- drug_trial[drug_trial$treatment == "placebo", ]
drugA <- drug_trial[drug_trial$treatment == "drugA", ]
drugB <- drug_trial[drug_trial$treatment == "drugB", ]

# ANOVA前提：1.随即独立取样。2.残差正态。3.方差相等
model = aov(pain~treatment, data=drug_trial)
plot(model)
shapiro.test(resid(model)) 
plot(model, 1) # 如果满足方差齐性的假设，预计图中的点将随机散布在水平线周围，并且自变量的所有水平上的方差大致相等 (一样高？)
bartlett.test(pain~treatment, data=drug_trial)
TukeyHSD(model)
summary(model)

# task2: 
mouse_weights <- read.csv("mouse_experiment.csv")
summary(mouse_weights)

anova_model <- aov(weight_gain ~ genotype * diet, 
                   data = mouse_weights)
summary(anova_model)
TukeyHSD(anova_model)



# problem set
# task1: t 检验vs有两个样本的单向方差分析
# 当单向方差分析中只有两组时，方差分析中使用的 F 检验在数学上相当于 t 检验。
# t 检验更直接，专门用于比较两组之间的平均值，而方差分析更通用
# task2: 模拟实验
group1 <- rnorm(30, 3, 1)
group2 <- rnorm(30, 4, 0.1)
group3 <- rnorm(30, 5, 0.01)
response <- c(group1, group2, group3)
group <- c(rep(1, 30), rep(2, 30), rep(3, 30))
data <- data.frame(group, response)
head(data)
model <- aov(response ~group, data)
plot(model, 1)







