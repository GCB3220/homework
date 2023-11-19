# task1
library(tidyverse)
GDP <- read.csv(file = "GDP.csv")
# na
anyNA(GDP)
# 将列名[X]替换为""
colnames(GDP) <-
  gsub(pattern = "[X]",
       replacement = "",
       x = colnames(GDP))
colnames(GDP)[1] <- "Country"
class(GDP$"1961")
# 取子集
GDP_subset <- subset(GDP, select = c(1, 5:60)) #删除无用
ncol(GDP_subset)# 列数
# gather:变为长格式
GDP_subset <- gather(GDP_subset, key = "Year", value = "GDP", 
                     2:57)
GDP_subset <- drop_na(GDP_subset)
# 选取特殊项
GDP_subset <- GDP_subset %>% filter(
  Country %in% c("Greece", "Germany", "France", "Italy") & 
    Year %in% c(1960, 1970, 1980, 1990, 2000, 2010, 2018))
# 整理
GDP_subset <- arrange(GDP_subset, Country, Year)
# 
GDP_subset <- mutate(GDP_subset, Year = as.integer(Year),
                     Country = as.factor(Country),
                     GDP = as.numeric(GDP))


# task2
g <- ggplot(data = GDP_subset, 
            aes(x = Year, y = GDP, color = Country))
g1 <- g + geom_point() + geom_line(aes(group = Country)) +
  geom_text(mapping = aes(label = GDP),
            hjust = 0.1,
            nudge_x = 0.05,
            size = 2) +
  labs(title = "GDP trends in the countries") +
  theme_bw()
g1
g2 <- g1 + scale_y_continuous(trans = 'log2') + 
  facet_wrap( ~ Country, ncol = 4) + 
  theme(axis.text.x = element_text(size = 9, angle = 45, vjust = 0.1))
g2
ggplot(data = GDP_subset, aes(
  x = Year,
  y = GDP,
  color = Country
)) +
  geom_point() +
  geom_smooth(method = "losess") +# 平滑
  theme_bw()
ggplot(data = GDP_subset, aes(
  x = Year,
  y = GDP,
  color = Country)) +
  geom_area(aes(fill = Country), position = "fill")


# task3
GDP_subset_2018 <- filter(GDP_subset, Year == 2018)
library(maps)
eu_map <- map_data("world", 
                   region = c("France", "Germany", "Italy", "Greece"))
# long经度lat纬度
ggplot(eu_map, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = region))
gdp.map <- left_join(eu_map, 
                     GDP_subset_2018, by = c("region"="Country"))
gmap <-
  ggplot(gdp.map, aes(x = long, y = lat, group = group)) + 
  geom_polygon(aes(fill = GDP))
gmap



# 保存
save.image(file = "week9_practice.RData")
