#
# file operation
list.files()
dir()
x <- scan() # 双enter
dir.create("C:/a/y-code/R1/R1")
# 详见1.2


# 帮助
help("quantile")
?quantile
example(quantile)
help(package = "dplyr")
?dplyr::select
args(quantile)


list_a = c( 5, 6, 4, 5, 10 )
list_a +1 #全加1
list_a[1]+3 
list_a[6] = 8 # 加一个项
number = sqrt(list_a) # 平方根
ma_a = matrix(list_a, ncol = 3) # 三列矩阵
getwd()
result = round(ma_a-list_a[1:4], 2) # 余两位, 减法顺列以列依次减


# 老鼠cancer分组
matrix_rat = matrix(c(17,15,7,25), ncol=2, byrow=TRUE)
rownames(matrix_rat) <- c("treament", "control")
colnames(matrix_rat) <- c("cancer", "normal")


# DP/DN/KO/WT
DP_KO <- c(57.27, 72.53, 64.67, 65.96, 55.99, 64.02, 65.60, 55.15, 
           72.90, 59.95)
DP_WT <- c(78.99, 77.63, 80.69, 83.49, 80.49, 80.79, 82.11, 80.10, 
           81.63, 78.82)
DN_KO <- c(19.72, 19.57, 26.02, 18.37, 12.35, 21.40, 17.75, 21.86, 
           15.07, 14.70)
DN_WT <- c(5.76, 3.80, 3.78, 7.21, 8.92, 5.75, 9.32, 5.82, 7.40, 
           10.69)
matrix_ko = cbind(DP_KO, DN_KO) # c:column
matrix_b <- cbind(
  DP_KO = DP_KO,
  DN_KO = DN_KO,
  DP_WT = DP_WT,
  DN_WT = DN_WT
)
mode(matrix_b) # 数据类型
class(matrix_b)# 类型:矩阵
frame_a <- as.data.frame(matrix_b)
frame_ko <- as.data.frame(matrix_ko)
frame_ko$situation <- c("Splenomegaly", "Splenomegaly", "Normal", 
                        "Normal", "Normal","Splenomegaly", "Normal",
                        "Splenomegaly","Splenomegaly", "Normal")

# 保存
write.csv(frame_ko, "a.csv", row.names = FALSE)
save(file = "filename.RData")




# problem set
frame_add <- data.frame(DP_KO=c(54, 42, NA), DN_KO=c(13, 15.54, NA),
                        DP_WT=c(8.67, 7.87, 9.5),
                        DN_WT=c(85.4, 77.45, 80.21))
#添加数据(但部分迷失)
frame_update <- rbind(frame_a, frame_add)
# problem set note
thymocytes <- rbind(c("KO", 13, 54, NA, NA),
                    c("KO", 15.54, 42, NA, NA),
                    c("WT", 8.67, 85.4, NA, NA),
                    c("WT", 7.87, 77.45, NA, NA),
                    c("WT", 9.5, 80.21, NA, NA))
tail(thymocytes)


# 读取数据, 转化为string
read_str <- read.csv("ADS2week1.csv")
read_str <- read_str[, -1] # 去掉第一列
# -:去掉, 1:2:1,2两列
PS1 <- c()
for(i in 1:ncol(read_str)){
  linE <- read_str[!is.na(read_str[,i]), i] # 行中所有非空/每列
  linE <- paste(linE, collapse = " ") # 将向量连接成单个字符串+空格分隔
  linE <- trimws(linE) # 从字符串中删除前导和尾随空格
  PS1[i] <- linE 
}
writeLines(PS1, "ADS2_PS1.txt")



save.image(file = "week1_practice.RData")
write.csv(frame_update, file="week1.csv", row.names=FALSE)




