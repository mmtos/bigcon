getwd()
.libPaths('/home/ubuntu/R/x86_64-pc-linux-gnu-library/3.2')

data <- read.csv("./CSVFile_2018-08-07T17_01_42.csv")

library(ggplot2)
library(sqldf)

###### 고객기본정보에 따른 금융정보 탐색 ######

### financial information ###
### TOT_ASSET(총자산), M_TOT_SAVING(월총저축액), TOT_DEBT(부채 잔액),  
### RETIRE_NEED(은퇴후 필요자금), FOR_RETIRE(노후자금용 월저축액), 
### TOT_SOBI(월총소비금액), M_CRD_SPD(월평균카드사용금액)

###### 2. INCOME_GBN ######

#소득분위별별 데이터 개수
ggplot(data=data, mapping=aes(as.factor(INCOME_GBN))) + 
  geom_bar(fill="#FF6666") +
  geom_text(stat = "count", aes(label=..count..), vjust=-0.5)

# 1(436), 2(1861), 3(2896), 4(2681), 5(2576), 6(4070), 7(2556)


### TOT_ASSET(총자산) ###

ggplot(data=data, aes(TOT_ASSET)) +
  geom_density(aes(fill=as.factor(INCOME_GBN)), alpha=0.4) +
  labs(title="TOT_ASSET by Income") +
  scale_x_continuous(limits=c(0, 10000)) +
  scale_fill_discrete(name="Income") +
  facet_grid( ~ INCOME_GBN)


### TOT_DEBT(부채 잔액) ###

ggplot(data=data, aes(TOT_DEBT)) +
  geom_density(aes(fill=as.factor(INCOME_GBN)), alpha=0.4) +
  labs(title="TOT_DEBT by Income") +
  scale_x_continuous(limits=c(0, 10)) +
  scale_fill_discrete(name="Income") +
  facet_grid( ~ INCOME_GBN)


### TOT_SOBI(월총소비금액) ###

range(data$TOT_SOBI)
quantile(data$TOT_SOBI)
ggplot(data=data, aes(TOT_SOBI)) +
  geom_density(aes(fill=as.factor(INCOME_GBN)), alpha=0.4) +
  labs(title="TOT_SOBI by Income") +
  scale_x_continuous(limits=c(0, 500)) +
  scale_fill_discrete(name="Income") +
  facet_grid( ~ INCOME_GBN)

