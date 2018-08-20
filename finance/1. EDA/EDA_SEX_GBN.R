getwd()
.libPaths('/home/ubuntu/R/x86_64-pc-linux-gnu-library/3.2')

data <- read.csv("./CSVFile_2018-08-07T17_01_42.csv")

library(ggplot2)
library(reshape2)
library(sqldf)

cor_data <- cor(data[,-1])
cor_data
#corrplot::corrplot(cor_data, method="number") #상관관계 그래프

###### 고객기본정보에 따른 금융정보 탐색 ######

### financial information ###
### TOT_ASSET(총자산), M_TOT_SAVING(월총저축액), TOT_DEBT(부채 잔액),  
### RETIRE_NEED(은퇴후 필요자금), FOR_RETIRE(노후자금용 월저축액), 
### TOT_SOBI(월총소비금액), M_CRD_SPD(월평균카드사용금액)

###### 1. SEX_GBN ######

male_info <- sqldf("select * from data where SEX_GBN==1")
count(male_info) #10081개
summary(male_info)

female_info <- sqldf("select * from data where SEX_GBN==2")
count(female_info) #6995개
summary(female_info)

male <- subset(data, SEX_GBN==1, select = c(TOT_ASSET, M_TOT_SAVING, TOT_DEBT, 
                                            RETIRE_NEED, FOR_RETIRE, 
                                            TOT_SOBI, M_CRD_SPD)) 
plot(male)

female <- subset(data, SEX_GBN==2, select = c(TOT_ASSET, M_TOT_SAVING, TOT_DEBT, 
                                            RETIRE_NEED, FOR_RETIRE, 
                                            TOT_SOBI, M_CRD_SPD))
plot(female)


### TOT_ASSET(총자산) ###
range(male$TOT_ASSET) #min : 30, max :415500
range(female$TOT_ASSET) #min :30, max : 364000

ggplot(data, aes(TOT_ASSET)) +
  geom_density(aes(fill=factor(SEX_GBN)), alpha=0.4) +
  labs(title="TOT_ASSET by Gender") +
  #scale_x_continuous(limits=c(0, 1000)) +
  scale_fill_discrete(name="Gender",labels=c("male", "female"))


### M_TOT_SAVING(월총저축액) ###
range(male$M_TOT_SAVING) #min : 1, max : 2300
range(female$M_TOT_SAVING) #min : 1, max : 2500

ggplot(data, aes(M_TOT_SAVING)) +
  geom_density(aes(fill=factor(SEX_GBN)), alpha=0.4) +
  labs(title="M_TOT_SAVING by Gender") +
  scale_x_continuous(limits=c(0, 500)) +
  scale_fill_discrete(name="Gender",labels=c("male", "female"))


### TOT_DEBT(부채 잔액) ###
range(male$TOT_DEBT) #min : 0, max : 60000
range(female$TOT_DEBT) #ming : 0, max : 53999

ggplot(data, aes(M_TOT_SAVING)) +
  geom_density(aes(fill=factor(SEX_GBN)), alpha=0.4) +
  labs(title="TOT_DEBT by Gender") +
  #scale_x_continuous(limits=c(0, 500)) +
  scale_fill_discrete(name="Gender",labels=c("male", "female"))


### RETIRE_NEED(은퇴후 필요자금) ###
range(na.omit(male$RETIRE_NEED)) #min : 10, max : 1000
range(na.omit(female$RETIRE_NEED)) #min : 10, max : 1000

ggplot(data, aes(RETIRE_NEED)) +
  geom_density(aes(fill=factor(SEX_GBN)), alpha=0.4) +
  labs(title="RETIRE_NEED by Gender") +
  #scale_x_continuous(limits=c(0, 500)) +
  scale_fill_discrete(name="Gender",labels=c("male", "female"))


### FOR_RETIRE(노후자금용 월저축액) ###
range(male$FOR_RETIRE) #min : 0, max : 2000
range(female$FOR_RETIRE) #min : 0, max : 800

ggplot(data, aes(FOR_RETIRE)) +
  geom_density(aes(fill=factor(SEX_GBN)), alpha=0.4) +
  labs(title="RETIRE_NEED by Gender") +
  #scale_x_continuous(limits=c(0, 100)) +
  scale_fill_discrete(name="Gender",labels=c("male", "female"))


### TOT_SOBI(월총소비금액) ### 
range(male$TOT_SOBI) #min : 1, max : 6000
range(female$TOT_SOBI) #min : 1, max : 5000

ggplot(data, aes(TOT_SOBI)) +
  geom_density(aes(fill=factor(SEX_GBN)), alpha=0.4) +
  labs(title="RETIRE_NEED by Gender") +
  #scale_x_continuous(limits=c(0, 1000)) +
  scale_fill_discrete(name="Gender",labels=c("male", "female"))


### M_CRD_SPD(월평균카드사용금액) ###
unique(data$M_CRD_SPD) #50개 유형

ggplot(data, aes(M_CRD_SPD)) +
  geom_density(aes(fill=factor(SEX_GBN)), alpha=0.4) +
  labs(title="RETIRE_NEED by Gender") +
  scale_fill_discrete(name="Gender",labels=c("male", "female"))

