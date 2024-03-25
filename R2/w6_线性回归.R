# task1
library(ggplot2)
library(tidyverse)
# 计算 COVID-19 数据集中给定国家/地区的指定变量的滚动平均值（前六天-今天变化）
generate_rolling_avg <- function(subcovid, one_country, one_variable, days = 7){
  range_days_in_one_country <- range(subcovid$date[which(subcovid$location == one_country)])
  dates_included <- seq(range_days_in_one_country[1], range_days_in_one_country[2],
                        by = "days")
  variable_means <- sapply(dates_included[-(1:6)], function(end_of_the_week){
    x_days_cases <- sapply(-6:0, function(y){
      subcovid[which(subcovid$location == one_country & subcovid$date == (end_of_the_week + y)),
               one_variable]
    })
    mean(x_days_cases)
  })
  variable_means_df <- data.frame(Dates = dates_included[-(1:6)],
                                  new_variable_avg = variable_means)
}

# 导入数据
trying <- try(covid <- read.csv("owid-covid-data.txt", header = TRUE)) 
if(is(trying, "try-error")){
  download.file(url = paste0("https://github.com/hugocarlos/covid-19-data/blob/master/",
                             "public/data/owid-covid-data.csv?raw=true"),
                destfile = "owid-covid-data.txt")
  covid <- read.csv("owid-covid-data.txt", header = TRUE)
}
# 选择数据
subcovid <- covid %>%
  select(iso_code, location, date, new_cases, new_deaths, new_cases_per_million,
         total_cases_per_million, new_vaccinations, people_fully_vaccinated,
         aged_65_older, aged_70_older, gdp_per_capita, extreme_poverty,
         cardiovasc_death_rate, diabetes_prevalence, life_expectancy,
         human_development_index)
# 改变格式
subcovid$date <- as.Date(subcovid$date)
# 计算七天内平均值
one_country <- "France"
cases_means_df <- generate_rolling_avg(subcovid, one_country, "new_cases", 7)
# 合并表
subcovid$new_cases_avg <- NA
for(i in 1:nrow(cases_means_df)){
  subcovid$new_cases_avg[which(subcovid$location == one_country &
                                 subcovid$date == cases_means_df$Dates[i])] <-
    cases_means_df$new_variable_avg[i]
}
# 绘图
ggplot() +
  geom_bar(stat = "identity",
           aes(x = subcovid$date[which(subcovid$location == one_country)],
               y = subcovid$new_deaths[which(subcovid$location == one_country)],
               colour = "New deaths")) + 
  geom_point(aes(x = subcovid$date[which(subcovid$location == one_country)],
               y = subcovid$new_cases[which(subcovid$location == one_country)],
               colour = "New cases"), size = 0.7) +
  geom_line(aes(x = subcovid$date[which(subcovid$location == one_country)],
                y = subcovid$new_cases_avg[which(subcovid$location == one_country)],
                colour = "7-day rolling average")) +
  labs(x = "Date", y = "Cases") +
  ggtitle(paste0("COVID-19 Cases and Deaths in ", one_country)) +
  theme(legend.position = c(0.2, 0.8),
        legend.title = element_blank(),
        legend.background = element_blank(),
        legend.key = element_rect(fill = NULL, color = NULL))
# 2021年所有数据
dates_from_2021 <- seq(as.Date("2021-01-01"), as.Date("2021-12-31"), by = "days")
one_country <- "Israel"
cases_means_df <- generate_rolling_avg(subcovid, one_country, "new_cases", 7)
# 联系人口数据
trying <- try(population <- read.csv("WBpopulation.csv", header = TRUE, sep = "\t"))
if(is(trying, "try-error")){
  download.file(url = paste0("https://raw.githubusercontent.com/hugocarlos/public_scripts/",
                             "master/teaching/WBpopulation.csv"),
                destfile = "WBpopulation.csv")
  population <- read.csv("WBpopulation.csv", header = TRUE, sep = "\t")
}
# 接种疫苗百分比
Israel_population <- population$X2020[which(population$Country.Name == one_country)]
subcovid$share_fully_vaccinated <- subcovid$people_fully_vaccinated * 100 / Israel_population
# 合并
subcovid$new_cases_avg <- NA
for(i in 1:nrow(cases_means_df)){
  subcovid$new_cases_avg[which(subcovid$location == one_country &
                                 subcovid$date == cases_means_df$Dates[i])] <-
    cases_means_df$new_variable_avg[i]
}
# 绘图
subcovid %>%
  filter(location == one_country) %>%
  filter(date >= dates_from_2021[1] & date < as.Date("2021-04-01")) %>%
  ggplot() +
  geom_point(aes(x = date, y = share_fully_vaccinated * 200,
                 colour = "Share of people fully vaccinated")) +
  geom_point(aes(x = date, y = new_cases_avg, colour = "New COVID-19 cases (7-day avg)")) +
  scale_y_continuous(name = "% of total population vaccinated",
                     sec.axis = sec_axis(~./200, name = "Number of cases",
                                         labels = function(b){
                                           paste0(b, "%")
                                         })) +
  xlab("Date") +
  theme(axis.title.y = element_text(color = "cyan4"),
        axis.title.y.right = element_text(color = "tomato"),
        legend.position = "bottom") +
  ggtitle(paste0(one_country))
# 疫苗可能存在影响
covid_onecountry <- subcovid[which(subcovid$location == "Israel" &
                                     subcovid$date >= as.Date("2021-01-15") &
                                     subcovid$date < as.Date("2021-03-31")), ]
# Correlation Coefficient
cor(covid_onecountry$new_cases_avg,
    covid_onecountry$share_fully_vaccinated,
    use = "complete.obs")
# 线性回归
lm_Israel <- lm(new_cases_avg ~ share_fully_vaccinated, covid_onecountry)
step(lm(new_cases_avg ~ share_fully_vaccinated+date+new_deaths, covid_onecountry))
summary(lm_Israel)
par(mfrow = c(2, 2))
plot(lm_Israel)
plot(lm_Israel, 4)
par(mfrow = c(1, 3))
hist(residuals(lm_Israel), breaks = 15, col = "gray",
     main = "Histogram of the residuals", xlab = "Residuals", cex = 0.6)
plot(lm_Israel, which = c(1, 2), cex = 0.6)
plot(x = covid_onecountry$share_fully_vaccinated, y = covid_onecountry$new_cases_avg,
     xlab = "New COVID-19 cases (7-day avg)",
     ylab = "% of population fully vaccinated")
abline(lm_Israel, col = "red")




# 教师解题


# problem set
anova/lm

