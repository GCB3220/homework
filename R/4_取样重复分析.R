# 取样重复分析






# task1
population <- rnorm(1e6,100,5)
popmean <- round(mean(population),1)
# 随机抽5个
sample_5 <- sample(population, 5)
sample_5_mean <- round(mean(sample_5), 1)
sample_5_sd <- round(sd(sample_5), 1)
# 抽取1000个大小为5的样本并绘制mean, sd变化
mean_for_1000 <- c()
sd_for_1000 <- c()
for (i in 1: 1000){
  sample_5 <- sample(population, 5)
  mean_for_1000 <- c(mean_for_1000, round(mean(sample_5), 1))
  sd_for_1000 <- c(sd_for_1000, round(sd(sample_5), 1))
}
hist(mean_for_1000, col = "green")
hist(sd_for_1000)
# 样本变大 -> 正态分布

# task 2
# 样本偏差: 早餐健康评判标准, 其他因素影响
# 健康的早餐本身并不能提高学生的学习成绩。相反，它可能是
#使学生更有可能在学校取得成功的其他因素的“症状”（例如
#父母或看护人，他们照顾得很好，身体健康，来自一个有钱的家庭，
#有组织的晨练，…）仅仅询问饮食问题，研究人员可能会错过
#真正的根本原因。
#•询问学生在特定的24小时内吃了什么可能不能代表他们的典型饮食
#或长期饮食行为。
#因为那个年龄的学生知道什么样的食物是健康的，健康的早餐是好的
#事情，他们可能不一定会说出自己饮食行为的真相（社会可取性
#偏置）。
#•通过询问在校学生，作者可能会想念生病或在家接受教育的儿童。


# task3 与个人隐私有关的问题:生日/是否偷窃
x = 2*112/300-181.25/365.25
x
nos <- 300*(0.5*184/365.25 + 0.5*(1-x))
nos


# 保存
save.image(file = "week4_practice.RData")
