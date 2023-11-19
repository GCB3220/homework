# diamond
library(ggplot2)
data(diamonds)
gg_point <- ggplot(diamonds, aes(x = carat, y = price, 
                                 group = cut))


# class
g <- ggplot(data = diamonds, 
            mapping = aes(x = carat, y = price, group = cut))
g1 <- g + geom_point(stat = "identity", 
                     aes(colour = cut), size = 1, alpha = 0.3)
# 划线/线性回归
g2 <- g1 + geom_smooth(method = "lm")
# 现在y长度
g3 <- g2 + scale_y_continuous(limits = c(0, 20500))
# 根据cut创建多面图
g4 <- g3 + facet_wrap(~cut, ncol = 2)
# 颜色c=色度,l=亮度
g5 <- g4 + scale_color_hue(l = 30, c = 50)
g5
# 保存
ggsave("plot.png", g5, width = 8, height = 6, units = "in")


# task1
gg_point + geom_point(stat = "identity", aes(colour = cut)) +
  labs(title = "Price vs Carat",x = "Carat", y = "Price")
# identity:直接映射
gg_point + geom_point(position = "identity",
                      aes(colour = cut),
                      size = 0.1,
                      alpha = 0.2)
# shape = 18:菱形
gg_point + geom_point(
  position = "jitter",
  aes(colour = cut),
  size = 0.6,
  alpha = 0.4,
  shape = 18) + 
  guides(color =
           guide_legend(override.aes = list(size = 6, alpha = 0.5)))
gg_point + geom_point(aes(colour = cut))+geom_smooth(method = "lm")
summary(gg_point)


# task2
gg_point + geom_area(aes(colour = cut), alpha = 0.3)
ggplot(diamonds, aes(x=carat)) + 
  stat_bin(binwidth = 0.5, fill = "blue", color = "black")
ggplot(diamonds, aes(x=carat))+geom_boxplot()
d <- ggplot(diamonds, aes(carat)) + xlim(0, 3) 
d + geom_histogram(stat = "count")
# guide
gg1 <-
  ggplot(data = diamonds,
         mapping = aes(x = carat, y = price, group = cut))
g2 <- gg1 + stat_identity(
  mapping = aes(color = cut),
  size = 0.6,
  geom = "point",
  shape = 3,
  position = "jitter"
)
# shape = 3:十字, 
# position = "jitter":添加少量随机噪声。
# 当同一坐标处存在重叠点时，通常会使用此方法，
# 有助于在视觉上将它们分开
g2


# task3
gg_box <- ggplot(diamonds, aes(x = clarity, y = carat))
gg_box + geom_boxplot(aes(color = cut)) + 
  geom_smooth(method = "lm") + 
  scale_color_brewer(palette = "Set1") +
  facet_grid(cut ~ color, scales = "fixed")

g <- ggplot(data = diamonds, mapping = aes(x = clarity, y = carat))
g3.1 <- g + geom_boxplot(outlier.size = 0.8)
g3.1
# 添加图层
sm <- geom_smooth(
  mapping = aes(x = as.integer(clarity)),
  method = "lm",
  se = F,
  size = 0.7
)
# se：代表标准错误。当 时se = FALSE，
# 这意味着您指示 ggplot2 不要包含平滑线周围的阴影区域，
# 该区域通常表示置信区间。
g3.2 <- g3.1 + sm
g3.2
g <- ggplot(data = diamonds, 
            mapping = aes(x = clarity, y = carat, color = cut))
g3.3 <- g + geom_boxplot(outlier.size = 0.8) + sm
g3.3
g3.4 <-
  g3.3 + ggtitle("Carats vs clarity") + 
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45),
    legend.position = "bottom"
  )
# 文本在最下, 倾斜45度角,水平对齐
g3.5 <- g3.4 + scale_color_brewer(palette = 3)# 调色
g3.5
# 根据颜色创建多面图?
g3.5 + facet_wrap(~ color)


# task4
g4.1 <- g3.2 + 
  scale_y_continuous(trans = "log10") + ylab("Carats, log10")
g4.1
library(cowplot)
g4.2.1 <- g +
  geom_boxplot(mapping = aes(y = carat)) +
  theme(legend.position = "none") +
  ggtitle("Original plot")
g4.2.2 <- g + geom_boxplot(mapping = aes(y = log10(carat))) +
  ggtitle("Change the aesthetic")
g4.2.3 <- g4.2.1 +
  scale_y_continuous(trans = "log10") +
  ggtitle("Change the Y-scale")
# 库中的此函数创建具有指定相对宽度、行数和按行排列的cowplot绘图网格
# mapping = aes(y = log10(carat)):直接y值变化 
# scale_y_continuous(trans = "log10"): 全局设置 y 轴比例的变换
plot_grid(g4.2.1, g4.2.2, g4.2.3, NULL,
          rel_widths = c(0.75, 1),
          nrow = 2, byrow = T)

g4.3.1 <- g4.2.2 + sm + theme(legend.position = "none")
g4.3.2 <- g4.2.2 + geom_smooth(
  mapping = aes(x = as.integer(clarity),y = log10(carat)), 
  method = "lm",
  se = F,
  size = 0.7)
plot_grid(g4.3.1, g4.3.2,
          rel_widths = c(0.75, 1),
          labels = c("Just apply `sm`", "Fix aesthetics in `sm`"))
plot_grid(g4.1, g4.1 + ylim(c(0.3, 1)))# 限制y值


# task5
samp <- sample(x = 1:nrow(diamonds), size = 200)
gg5 <-
  ggplot(data = diamonds[samp,], mapping = aes(x = clarity, y = carat))
g5.1 <- gg5 + geom_boxplot(outlier.size = 0.8) +
  geom_jitter(width = 0.1,
              mapping = aes(size = carat, color = price))
g5.1
g5.2 <- g5.1 + scale_color_gradient(limits = c(10000, 15000))
g5.3 <- g5.1 + scale_size_continuous(limits = c(1.2, 2))
plot_grid(
  g5.2,
  g5.3,
  ncol = 2,
  nrow = 1,
  labels = c("scale_color_gradient", "scale_size_continous"),
  hjust = -0.26
)


# task6
gg6 <- ggplot(data = diamonds, mapping = aes(x = clarity, group = cut))
g6.1 <-
  gg6 + geom_bar(mapping = aes(fill = cut), position = "stack") +
  ggtitle("Stacking") + theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.y = element_text(size = 10),
    axis.text.x = element_text(size = 7),
    legend.position = "n",
    aspect.ratio = 7 / 7
  )
g6.2 <-
  gg6 + geom_bar(mapping = aes(fill = cut), position = "fill") +
  ggtitle("Filling") + theme(
    plot.title = element_text(hjust = 0.5),
    axis.text = element_text(size = 9),
    axis.text.y = element_text(size = 10),
    axis.text.x = element_text(size = 7),
    legend.position = "right",
    aspect.ratio = 7 / 5
  )
g6.3 <-
  gg6 + geom_bar(mapping = aes(fill = cut), position = "dodge") +
  ggtitle("Positioning near") + theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(size = 7),
    axis.text.y = element_text(size = 10),
    legend.position = "n",# 图例不显示
    aspect.ratio = 7 / 7 # 绘图的纵横比:高度将为宽度的 7/7 倍
  )
plot_grid(
  plotlist = list(g6.1, g6.2, g6.3, NULL),
  rel_widths = c(0.75, 1.25),
  rel_heights = 1
)




# 保存/删除
rm(raw_scores)
save.image(file = "week9.RData")
