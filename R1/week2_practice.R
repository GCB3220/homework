# task1
# 100名学生查看成绩
# 平均86,标准差5.0,绘图
sample_for_students <- rnorm(100, mean=86, sd=5.0)
hist(sample_for_students, main="histogram for students grade", xlab = 
       "grade", ylab="people", col="red")
# 成绩大于91/小于86
higher_than_91 <- sum(sample_for_students>91)
lower_than_86 <- sum(sample_for_students<86)
# 问题:???
# 太随机? 分数超100


# task2
# 考试策略
# 20道4项选择题
question_ABCD <- sample(1:4, 20, replace=TRUE)
# 全选A vs 全随机
A_pass <- 0
random_pass <-0
for (i in 1:10000){
  question_ABCD <- sample(1:4, 20, replace=TRUE)
  all_in_A <- sum(question_ABCD==1)
  random_answer <- sample(1:4, 20, replace=TRUE)
  random_score <- sum(question_ABCD==random_answer)
  if (all_in_A>10){
    A_pass <- A_pass+1
  }
  if (random_score>10) random_pass <- random_pass+1
}
# ABCD频率一致
question_ABCD_same <- sample(1:4, 20, replace = TRUE, 
                             prob = c(1/4, 1/4, 1/4, 1/4))

# final
# 保存工作环境
save.image(file = "week2_practice.RData")
