library(tidyverse);library(openxlsx);library(zoo)
library(magrittr);library(splines)

data=read.xlsx('owid-covid-data.xlsx') %>% mutate(date=as.Date(date))
trying<-try(population<-read.csv("WBpopulation.csv",header=T,sep="\t"))
if(is(trying, "try-error")){
	download.file(url=paste0("https://raw.githubusercontent.com/hugocarlos/",
													 "public_scripts/master/teaching/WBpopulation.csv"),
								destfile="WBpopulation.csv")
population=read.csv("WBpopulation.csv",header=T,sep="\t")
}

###  Do you consider this correlation good enough to infer 
###  that the vaccination in Israel had an effect on the 
###  number of new infections during the first three months of 2021?
Israel_population=filter(population,Country.Name=='Israel')
df1=data %>% filter(location=='Israel') %>%
	filter(between(date,as.Date("2021-01-15"),as.Date("2021-03-31"))) %>%
	mutate(new_cases_avg=rollmean(new_cases,7,fill=NA,align='left'),
				 share_fully_vaccinated=people_fully_vaccinated*100/population)
cor(df1$new_cases_avg,df1$share_fully_vaccinated,use='complete.obs')
fit=lm(new_cases_avg~share_fully_vaccinated,data=df1)
summary(fit)
# correlation is -0.9706056 so negatively strong

### What other factors would you add to the 
### linear regression to improve the fit?
fit1=lm(new_cases_avg~share_fully_vaccinated*positive_rate+new_tests,data=df1)
summary(fit1)
fit2=lm(new_cases_avg~share_fully_vaccinated+positive_rate+new_tests,data=df1)
summary(fit2)
anova(fit1,fit2)

### Can you find another country (or countries) 
### where the correlation between the share of the population 
### that have received one or the full number of doses 
### closely correlates with the recent number of new COVID-19 infections?
df2=data %>% 
	filter(between(date,as.Date("2022-01-18"),as.Date("2023-01-18"))) %>%
	select(c('date','location','new_cases','people_vaccinated',
					 'people_fully_vaccinated','population')) %>%
	group_by(location) %>% group_split() %>%
	map(~mutate(.x,new_cases_avg=rollmean(new_cases,7,fill=NA),
							share_one_vaccinated=people_vaccinated*100/population,
							share_fully_vaccinated=people_fully_vaccinated*100/population)) %>%
	map(~na.omit(.x)) %>% 
	# n>30 makes sure normality
	keep(function(x) nrow(x)>30)

sum_table=map(df2,~summarise(.x,location=unique(location),
														 corr_onevac=cor(.x$new_cases_avg,.x$share_one_vaccinated),
														 corr_fullvac=cor(.x$new_cases_avg,share_fully_vaccinated))) %>%
	bind_rows()

### Consider a restricted period of time (around Winter or around Summer),
### not all countries might be equally affected by the change of the seasons.
# summer
df3=data %>%
	filter(between(date,as.Date("2021-06-18"),as.Date("2021-09-18"))) %>%
	select(c('date','location','new_cases','people_vaccinated',
					 'people_fully_vaccinated','population')) %>%
	group_by(location) %>% group_split() %>%
	map(~mutate(.x,new_cases_avg=rollmean(new_cases,7,fill=NA),
							share_fully_vaccinated=people_fully_vaccinated*100/population)) %>%
	map(~na.omit(.x)) %>% keep(function(x) nrow(x)>30)

sum_table=df3 %>%
	map(~lm(new_cases_avg~share_fully_vaccinated,data=.x)) %>%
	map(~summary(.x)) %>%
	map(~data.frame(slope=.x$coefficients[2,1],slope_p=.x$coefficients[2,4],
									rsqr=.x$r.squared)) %>%
	bind_rows() %>%
	mutate(location=bind_rows(df3) %>% distinct(location) %>% .$location)
# winter
df4=data %>%
	filter(between(date,as.Date("2021-12-18"),as.Date("2021-02-18"))) %>%
	select(c('date','location','new_cases','people_vaccinated',
					 'people_fully_vaccinated','population')) %>%
	group_by(location) %>% group_split() %>%
	map(~mutate(.x,new_cases_avg=rollmean(new_cases,7,fill=NA),
							share_fully_vaccinated=people_fully_vaccinated*100/population)) %>%
	map(~na.omit(.x)) %>% keep(function(x) nrow(x)>30)

sum_table=df4 %>%
	map(~lm(new_cases_avg~share_fully_vaccinated,data=.x)) %>%
	map(~summary(.x)) %>%
	map(~data.frame(slope=.x$coefficients[2,1],slope_p=.x$coefficients[2,4],
									rsqr=.x$r.squared)) %>%
	bind_rows() %>%
	mutate(location=bind_rows(df3) %>% distinct(location) %>% .$location)

### Choose one country and develop a method that 
### uses local linear regressions to assess when during the
### COVID-19 epidemic it is observed an increase, 
### a decrease or no change in the number of new cases.
### The output could be a table showing that 
### for some periods of time (for example from October to mid November) 
### there was an increase or a decrease in cases.
df4=data %>%
	filter(location=='Japan') %>%
	select(c('date','location','new_cases','people_vaccinated',
					 'population')) %>%
	mutate(date=format(date,'%Y-%m') %>% as_date(format='%Y-%m')) %>%
	mutate(new_cases_avg=rollmean(new_cases,30,fill=NA),
				 share_vaccinated=people_vaccinated*100/population)

ggplot(df4,aes(group=1))+theme_light()+
	geom_line(aes(date,share_vaccinated*200,
								colour="Share of people vaccinated"),
						linewidth=1,alpha=.5)+
	geom_line(aes(date,new_cases_avg,colour="New COVID-19 cases (30-day avg)"),
						linewidth=1,alpha=.5)+
	scale_y_continuous(name="% of total population vaccinated",n.breaks=10,
										 sec.axis=sec_axis(~./200,name="Number of cases",
										 									labels=function(b){paste(b,"%")}))+
	scale_x_date(date_breaks='3 months',
							 labels=function(b){format(b,'%Y-%b')})+
	labs(x='')+scale_colour_manual(values=c('red','blue'))+
	theme(axis.text.x=element_text(angle=45,vjust=.7,hjust=.8),
				axis.title.y=element_text(colour="blue"),
				axis.title.y.right=element_text(colour="red"),
				legend.position='top')
# plot_time_series_regression(df4,date,
# 														new_cases_avg~date,
# 														.show_summary=T)
df4 %<>% 
	mutate(time_cut=cut(date,breaks=as.Date(c('2020-01-01','2021-06-01',
																						'2021-11-01','2022-02-01',
																						'2022-06-01','2022-08-01',
																						'2022-11-01','2023-01-01',
																						'2023-02-01')),
											labels=c('2020/01-2021/06','2021/06-2021/11',
															 '2021/11-2022/02','2022/02-2022/06',
															 '2022/06-2022/08','2022/08-2022/11',
															 '2022/11-2023/01','2023/01-2023/02')))

ggplot(df4,aes(date,new_cases_avg))+theme_light()+
	geom_line(aes(date,new_cases_avg,colour="New COVID-19 cases (30-day avg)"),
						linewidth=1)+
	scale_y_continuous(name='New COVID-19 cases (30-day avg)',n.breaks=10)+
	scale_x_date(date_breaks='3 months',name='',
							 labels=function(b){format(b,'%Y-%b')})+
	facet_wrap(~time_cut)+
	geom_smooth(formula=y~x,method='lm',linetype='dashed',alpha=.5)+
	theme(axis.text.x=element_text(angle=45,vjust=.7,hjust=.8),
				legend.position='top')

df4 %>% group_by(time_cut) %>% group_split() %>%
	map(~lm(data=.x,new_cases_avg~date)) %>% .[c(1:6)] %>%
	map(~summary(.x)) %>%
	map(~data.frame(slope=.x$coefficients[2,1],slope.se=.x$coefficients[2,2],
									slope.p=.x$coefficients[2,4],
									rsqr=.x$r.squared)) %>% bind_rows() %>%
	mutate(period=c('2020/01-2021/06','2021/06-2021/11',
									'2021/11-2022/02','2022/02-2022/06',
									'2022/06-2022/08','2022/08-2022/11'),
				 .before=slope)

# just trying (spline) 不重要
lm(new_cases_avg~bs(date,knots=as.Date(c('2021-06-01','2021-11-01',
																				 '2022-02-01','2022-06-01',
																				 '2022-08-01','2022-11-01',
																				 '2023-01-01'))),data=df4) %>%
	summary
