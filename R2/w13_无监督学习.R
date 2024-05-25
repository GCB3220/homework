# 聚类

# task1: k-means, k=4
guests <- read.csv("guests.csv")

guests$cluster <- NA  # 添加一个簇标签列，初始化为NA
guests <- cbind(guests, matrix(NA, nrow(guests), 4))  # 添加四列用于存放距离
colnames(guests)[c(5:8)] <- c(paste0("dist_", 1:4))

centroids <- guests[sample(1:nrow(guests), 4, replace = FALSE), ]
centroids$cluster <- c(1, 2, 3, 4) 

library(ggplot2)
p <- ggplot(guests, aes(x=age_norm, y=hours_norm)) +
  geom_point() +
  geom_point(data=centroids, aes(x=age_norm, y=hours_norm), shape=3, size=2, colour="red")
p



for (i in 1: nrow(guests)) {
  for (j in 1:4) {
    guests[i, j+4] <- sqrt((guests[i, 2]-centroids$age_norm[j])^2 + 
                         (guests[i, 3]-centroids$hours_norm[j])^2)
  }
}

for (i in 1: nrow(guests)) {
  j <- guests[i, -1:-4]
  guests$cluster[i] <- which(j == min(guests[i, -1:-4]))
}


centroids <- data.frame(age_norm = c(0, 0, 0, 0), 
                        hours_norm = c(0, 0, 0, 0), 
                        cluster = c(1, 2, 3, 4) )

for (i in 1: 4) {
  centroids$age_norm[i] <- mean(guests$age_norm[guests$cluster == i])
  centroids$hours_norm[i] <- mean(guests$hours_norm[guests$cluster == i])
}

p+geom_point(data=centroids, aes(x=age_norm, y=hours_norm), shape=3, size=2, colour="blue")




# task2: Hierarchical clustering
guests <- read.csv("guests.csv")

distance_matrix <- dist(guests[, c("age_norm", "hours_norm")])

hc <- hclust(distance_matrix)

plot(hc, hang = -1, labels = guests$names)
