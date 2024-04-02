# task1: 被测撒谎者中小偷人数
# 1. 模拟
num_employees <- 1000  
p_stealing <- 0.10
theft <- 0

lie_test_results <- rep(0, num_employees)  
for (i in 1:num_employees) {
  if (runif(1) <= p_stealing) {
    n <- sample(c(1, 0), 1, prob = c(0.8, 0.2))
    if (n == 1) {theft <- theft+1}
    lie_test_results[i] <- n
  } else{
    lie_test_results[i] <- sample(c(1, 0), 1, prob = c(0.2, 0.8))
  }
}

num_lying <- sum(lie_test_results)

theft/num_lying

# 2. 贝叶斯理论
# p_theft <- 0.1
# p_no_theft <- 0.9
# no_theft: positive 0.2, negative 0.8
# no_theft: : positive 0.8, negative 0.2
matrix(data = c(0.2*0.9, 0.8*0.9, 0.8*0.1, 0.2*0.1), byrow = T, nrow = 2,
       dimnames = list(c("no_theft", "theft"), c("positive", "negative")))
# p_postive = 0.26
50/0.26*0.08
# p(theft|positive) = p(theft)*p(positive|theft)/p(positive)
50*0.1*0.8/0.26


# task2:硬币
num <- c()
for (i in 1:1000){
  seq <- sample(c("H", "T"), 1)
  n <- 0
  repeat {
    seq <- paste(seq, sample(c("H", "T"), 1), sep = "")
    n <- n+1
    if (grepl("HTTH", seq)) {break}
  }
  num <- c(num, n)
}
mean(num)
