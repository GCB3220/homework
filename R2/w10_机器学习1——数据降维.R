mnist_raw <- read.csv("mnist_train.csv", header = F)
mnist_raw[1:10, 1:10]

# http://varianceexplained.org/r/digit-eda/

library(tidyr)
library(readr)
library(dplyr)
# Label: 这是原始的手写数字标签，范围从0到9
# Instance: 这是示例编号，范围从1到1000，代表数据集中的图像序号。
# Pixel: 这是像素编号，范围从0到783，代表图像中的单个像素点
# Value: 这是像素值，范围从0到255，代表像素的灰度强度
# X 和 Y: 这些是像素的坐标。代表像素在图像中的位值
pixels_gathered <- mnist_raw %>%
  head(10000) %>%
  rename(label = V1) %>%
  mutate(instance = row_number()) %>%
  gather(pixel, value, -label, -instance) %>%
  tidyr::extract(pixel, "pixel", "(\\d+)", convert = TRUE) %>%
  mutate(pixel = pixel - 2,
         x = pixel %% 28,
         y = 28 - pixel %/% 28)

pixels_gathered

# 可视化
library(ggplot2)
theme_set(theme_light())

pixels_gathered %>%
  filter(instance <= 12) %>%
  ggplot(aes(x, y, fill = value)) +
  geom_tile() +
  facet_wrap(~ instance + label)

# 灰色跨度/边界
ggplot(pixels_gathered, aes(value)) +
  geom_histogram()

# 每个标签中每个位置的平均值
pixel_summary <- pixels_gathered %>%
  group_by(x, y, label) %>%
  summarize(mean_value = mean(value)) %>%
  ungroup()

pixel_summary


# 平均数字可视化
pixel_summary %>%
  ggplot(aes(x, y, fill = mean_value)) +
  geom_tile() +
  scale_fill_gradient2(low = "white", high = "black", mid = "gray", midpoint = 127.5) +
  facet_wrap(~ label, nrow = 2) +
  labs(title = "Average value of each pixel in 10 MNIST digits",
       fill = "Average value") +
  theme_void()

# 图像到其标签质心的欧几里得距离（平方和的平方根）
pixels_joined <- pixels_gathered %>%
  inner_join(pixel_summary, by = c("label", "x", "y"))

image_distances <- pixels_joined %>%
  group_by(label, instance) %>%
  summarize(euclidean_distance = sqrt(mean((value - mean_value) ^ 2)))

image_distances

ggplot(image_distances, aes(factor(label), euclidean_distance)) +
  geom_boxplot() +
  labs(x = "Digit",
       y = "Euclidean distance to the digit centroid")

# 可视化与其中心数字最不相似的六位数实例。
worst_instances <- image_distances %>%
  top_n(6, euclidean_distance) %>%
  mutate(number = rank(-euclidean_distance))

pixels_gathered %>%
  inner_join(worst_instances, by = c("label", "instance")) %>%
  ggplot(aes(x, y, fill = value)) +
  geom_tile(show.legend = FALSE) +
  scale_fill_gradient2(low = "white", high = "black", mid = "gray", midpoint = 127.5) +
  facet_grid(label ~ number) +
  labs(title = "Least typical digits",
       subtitle = "The 6 digits within each label that had the greatest distance to the centroid") +
  theme_void() +
  theme(strip.text = element_blank())

# 尝试重叠我们的质心数字对，并取它们之间的差异
digit_differences <- crossing(compare1 = 0:9, compare2 = 0:9) %>%
  filter(compare1 != compare2) %>%
  mutate(negative = compare1, positive = compare2) %>%
  gather(class, label, positive, negative) %>%
  inner_join(pixel_summary, by = "label") %>%
  select(-label) %>%
  spread(class, mean_value)

ggplot(digit_differences, aes(x, y, fill = positive - negative)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = .5) +
  facet_grid(compare2 ~ compare1) +
  theme_void() +
  labs(title = "Pixels that distinguish pairs of MNIST images",
       subtitle = "Red means the pixel is darker for that row's digit, and blue means the pixel is darker for that column's digit.")

# practical solution 
features = data.frame(label = mnist_raw$V1[1:1000])
# 建表
for (i in 1:56) features = cbind(features, fi = c(1:1000)*0)
# 取每一行每一列平均值作为特征
for (i in 1:28) { 
  for (j in 1:1000) { 
    features[j,i+1] = mean(pixels_gathered$value[pixels_gathered$instance==j & pixels_gathered$y==i]);
    features[j,i+29] = mean(pixels_gathered$value[pixels_gathered$instance==j & pixels_gathered$x==i-1]);
  }
}



# problem set
# 平均值
fstats = matrix(1:560, nrow = 10, ncol = 56)
for (i in 1:10)
  for (j in 1:56)
    fstats[i,j] = mean(features[features$label==i-1,j+1]);

par(mfrow=c(5,2))
for (i in 1:10)
{ plot(fstats[i,], ylab = "Value", xlab = "Feature index")
  title(paste("Feature values for digit", toString(i-1)))
}









# task2
library(nnet)
rows <- sample(1:1000, 700)
train_labels <- features[rows, 1]
valid_labels <- features[-rows, 1]
train_data <- features[rows, -1]
valid_data <- features[-rows, -1]

train_labels_matrix = class.ind(train_labels)
nn = nnet(train_data, train_labels_matrix, size = 4, softmax = TRUE)

pred_train = predict(nn, train_data, type="class")
pred_valid = predict(nn, valid_data, type="class")

mean(pred_train == train_labels)
mean(pred_valid == valid_labels)
