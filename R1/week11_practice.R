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
# H0
t.test(mouse$before, mouse$after, 
       paired = TRUE, var.equal=TRUE)
# HA



# 保存
rm(filed_B)
save.image(file = "week11_practice.RData")
