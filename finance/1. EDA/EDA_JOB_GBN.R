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

###### 2. JOB_GBN ######

#직업별 데이터 개수
ggplot(data=data, mapping=aes(as.factor(JOB_GBN))) + 
  geom_bar(fill="#FF6666") +
  geom_text(stat = "count", aes(label=..count..), vjust=-0.5) 

# 2(사무직):8623, 3(공무원):1000, 4(전문직(근로직)):583,
# 6(전문직(자영업)):313, 7(판매서비스):819, 8(기능직):1482, 
# 9(일반자영업):2329, 10(프리랜서):1251, 11(대학원생, 기타):676

### TOT_ASSET(총자산) ###

ggplot(data=data, aes(x=TOT_ASSET)) +
  geom_density(aes(fill=as.factor(JOB_GBN)), alpha=0.4) +
  labs(title="TOT_ASSET by Job") +
  #scale_x_continuous(limits=c(0, 100000)) +
  scale_fill_discrete(name="Job")
  #facet_wrap( ~ JOB_GBN, ncol=2)


### M_TOT_SAVING(월총저축액) ###

ggplot(data=data, aes(x=M_TOT_SAVING)) +
  geom_density(aes(fill=as.factor(JOB_GBN)), alpha=0.4) +
  labs(title="M_TOT_SAVING by Job") +
  #scale_x_continuous(limits=c(0, 500)) +
  scale_fill_discrete(name="Job") 
  #facet_wrap( ~ JOB_GBN, ncol=2)
  

### TOT_DEBT(부채 잔액) ###

summary(data[data$JOB_GBN==2,'TOT_DEBT']) #min:0, median:540, 3rd:5000, max:60000
summary(data[data$JOB_GBN==3,'TOT_DEBT']) #min:0, median:840, 3rd:5000, max:43000
summary(data[data$JOB_GBN==4,'TOT_DEBT']) #min:0, median:250, 3rd:3250, max:31300
summary(data[data$JOB_GBN==6,'TOT_DEBT']) #min:0, median:475, 3rd:4000, max:30000
summary(data[data$JOB_GBN==7,'TOT_DEBT']) #min:0, median:200, 3rd:2651, max:51000
summary(data[data$JOB_GBN==8,'TOT_DEBT']) #min:0, median:500, 3rd:4000, max:40000
summary(data[data$JOB_GBN==9,'TOT_DEBT']) #min:0, median:1000, 3rd:6000, max:46700
summary(data[data$JOB_GBN==10,'TOT_DEBT']) #min:0, median:90, 3rd:3000, max:53999
summary(data[data$JOB_GBN==11,'TOT_DEBT']) #min:0, median:95, 3rd:2004, max:34400

ggplot(data=data, aes(x=TOT_DEBT)) +
  geom_density(aes(fill=as.factor(JOB_GBN)), alpha=0.4) +
  labs(title="TOT_DEBT by Job") +
  #scale_x_continuous(limits=c(0, 10000)) +
  scale_fill_discrete(name="Job") 
  #facet_wrap( ~ JOB_GBN, ncol=2)

ggplot(data=data, aes(x=TOT_DEBT)) +
  geom_boxplot(outlier.color='red', outlier.shape=2) +
  scale_y_continuous(limits=c(0, 100)) 


### RETIRE_NEED(은퇴후 필요자금) ###

ggplot(data=data, aes(x=RETIRE_NEED)) +
  geom_density(aes(fill=as.factor(JOB_GBN)), alpha=0.4) +
  labs(title="TOT_DEBT by Job") +
  #scale_x_continuous(limits=c(0, 10000)) +
  scale_fill_discrete(name="Job") 
  #facet_wrap( ~ JOB_GBN, ncol=2)


### FOR_RETIRE(노후자금용 월저축액) ###

ggplot(data=data, aes(x=FOR_RETIRE)) +
  geom_density(aes(fill=as.factor(JOB_GBN)), alpha=0.4) +
  labs(title="TOT_DEBT by Job") +
  #scale_x_continuous(limits=c(0, 100)) +
  scale_fill_discrete(name="Job") 
  #facet_wrap( ~ JOB_GBN, ncol=2)


### TOT_SOBI(월총소비금액) ###

ggplot(data=data, aes(x=TOT_SOBI)) +
  geom_density(aes(fill=as.factor(JOB_GBN)), alpha=0.4) +
  labs(title="TOT_DEBT by Job") +
  #scale_x_continuous(limits=c(0, 2000)) +
  scale_fill_discrete(name="Job") 
  #facet_wrap( ~ JOB_GBN, ncol=2)


### M_CRD_SPD(월평균카드사용금액) ###

ggplot(data=data, aes(x=M_CRD_SPD)) +
  geom_density(aes(fill=as.factor(JOB_GBN)), alpha=0.4) +
  labs(title="TOT_DEBT by Job") +
  scale_fill_discrete(name="Job") 
  #facet_wrap( ~ JOB_GBN, ncol=2)
