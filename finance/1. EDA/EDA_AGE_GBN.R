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

###### 2. AGE_GBN ######

#연령별 데이터 개수
ggplot(data=data, mapping=aes(as.factor(AGE_GBN))) + 
  geom_bar(fill="#FF6666") +
  geom_text(stat = "count", aes(label=..count..), vjust=-0.5) 
# 20대(3355), 30대(4252), 40대(4689), 50대(3882), 60대(898)

twenty_info <- sqldf("select * from data where AGE_GBN==2")
summary(twenty_info)

thirty_info <- sqldf("select * from data where AGE_GBN==3")
summary(thirty_info)

forty_info <- sqldf("select * from data where AGE_GBN==4")
summary(forty_info)

fifty_info <- sqldf("select * from data where AGE_GBN==5")
summary(fifty_info)

sixty_info <- sqldf("select * from data where AGE_GBN==6")
summary(sixty_info)


### TOT_ASSET(총자산) ###

range(twenty_info[,'TOT_ASSET']) #min:30, max:415500
range(thirty_info[,'TOT_ASSET']) #min:30, max:360000
range(forty_info[,'TOT_ASSET']) #min:30, max:311700
range(fifty_info[,'TOT_ASSET']) #min:41, max:364000
range(sixty_info[,'TOT_ASSET']) #min:200, max:330900

ggplot(data=data, aes(x=TOT_ASSET)) +
  geom_density(aes(fill=as.factor(AGE_GBN)), alpha=0.4) +
  labs(title="TOT_ASSET by Age") +
  scale_x_continuous(limits=c(0, 100000)) +
  scale_fill_discrete(name="Age", labels=c("20", "30", "40", "50", "60"))+
  facet_grid(. ~ AGE_GBN)


### M_TOT_SAVING(월총저축액) ###

range(data[data$AGE_GBN==2,'M_TOT_SAVING']) #min:1, max:2000
range(data[data$AGE_GBN==3,'M_TOT_SAVING']) #min:1, max:2200
range(data[data$AGE_GBN==4,'M_TOT_SAVING']) #min:1, max:2300
range(data[data$AGE_GBN==5,'M_TOT_SAVING']) #min:1, max:2500
range(data[data$AGE_GBN==6,'M_TOT_SAVING']) #min:1, max:1708

ggplot(data=data, aes(x=M_TOT_SAVING)) +
  geom_density(aes(fill=as.factor(AGE_GBN)), alpha=0.4) +
  labs(title="M_TOT_SAVING by Age") +
  #scale_x_continuous(limits=c(0, 1000)) +
  scale_fill_discrete(name="Age", labels=c("20", "30", "40", "50", "60")) +
  facet_grid(. ~ AGE_GBN)


### TOT_DEBT(부채 잔액) ###

summary(twenty_info[,'TOT_DEBT']) #min:0, 3rd:1020, max:32730
summary(thirty_info[,'TOT_DEBT']) #min:30, 3rd:5000, max:46500
summary(forty_info[,'TOT_DEBT']) #min:0, 3rd:6000, max:53999
summary(fifty_info[,'TOT_DEBT']) #min:0, 3rd:6000, max:60000
summary(sixty_info[,'TOT_DEBT']) #min:0, 3rd:5500, max:47100

ggplot(data=data, aes(x=TOT_DEBT)) +
  geom_histogram(aes(y=..density.., fill=as.factor(AGE_GBN)), alpha=0.4, bins=10) +
  geom_density(alpha=.2) +
  labs(title="TOT_DEBT by Age") +
  scale_fill_discrete(name="Age", labels=c("20", "30", "40", "50", "60"))


### RETIRE_NEED(은퇴후 필요자금) ###

summary(na.omit(forty_info[,'RETIRE_NEED'])) #min:10, 3rd:300, max:1000
summary(na.omit(fifty_info[,'RETIRE_NEED'])) #min:10, 3rd:250, max:600
summary(na.omit(sixty_info[,'RETIRE_NEED'])) #min:50, 3rd:300, max:700

ggplot(data=data, aes(x=RETIRE_NEED)) +
  geom_histogram(aes(y=..density.., fill=as.factor(AGE_GBN)), alpha=0.4, bins=10) +
  geom_density(alpha=.2) +
  labs(title="RETIRE_NEED by Age") +
  scale_fill_discrete(name="Age", labels=c("40", "50", "60"))

ggplot(data=data, aes(x=RETIRE_NEED)) +
  geom_density(aes(fill=as.factor(AGE_GBN)), alpha=0.4) +
  labs(title="RETIRE_NEED by Age") +
  #scale_x_continuous(limits=c(0, 1000)) +
  scale_fill_discrete(name="Age", labels=c("40", "50", "60"))


### FOR_RETIRE(노후자금용 월저축액) ###

summary(twenty_info[,'FOR_RETIRE']) #min:0, 3rd:20, max:500
summary(thirty_info[,'FOR_RETIRE']) #min:30, 3rd:30, max:2000
summary(forty_info[,'FOR_RETIRE']) #min:0, 3rd:30, max:800
summary(fifty_info[,'FOR_RETIRE']) #min:0, 3rd:50, max:800
summary(sixty_info[,'FOR_RETIRE']) #min:0, 3rd:40, max:700

ggplot(data=data, aes(x=as.factor(AGE_GBN), y=FOR_RETIRE)) +
  geom_boxplot(outlier.color='red', outlier.shape=2) +
  scale_y_continuous(limits=c(0, 100)) 

ggplot(data=data, aes(x=FOR_RETIRE)) +
  geom_density(aes(fill=as.factor(AGE_GBN)), alpha=0.4) +
  labs(title="FOR_RETIRE by Age") +
  scale_x_continuous(limits=c(0, 50)) +
  scale_fill_discrete(name="Age", labels=c("20", "30", "40", "50", "60"))


### TOT_SOBI(월총소비금액) ###

summary(twenty_info[,'TOT_SOBI']) #min:1, 3rd:148, max:5000
summary(thirty_info[,'TOT_SOBI']) #min:1, 3rd:250, max:2500
summary(forty_info[,'TOT_SOBI']) #min:1, 3rd:350, max:6000
summary(fifty_info[,'TOT_SOBI']) #min:3, 3rd:400, max:3600
summary(sixty_info[,'TOT_SOBI']) #min:7, 3rd:350, max:2000

ggplot(data=data, aes(x=as.factor(AGE_GBN), y=TOT_SOBI)) +
  geom_boxplot(outlier.color='red', outlier.shape=2) +
  scale_y_continuous(limits=c(0, 1000)) 

ggplot(data=data, aes(x=TOT_SOBI)) +
  geom_histogram(aes(y=..density.., fill=as.factor(AGE_GBN)), alpha=0.4, bins=10) +
  geom_density(alpha=.2) +
  labs(title="TOT_SOBI by Age") +
  scale_x_continuous(limits=c(0, 500)) +
  scale_fill_discrete(name="Age", labels=c("20", "30", "40", "50", "60"))

ggplot(data=data, aes(x=TOT_SOBI)) +
  geom_density(aes(fill=as.factor(AGE_GBN)), alpha=0.4) +
  labs(title="TOT_SOBI by Age") +
  #scale_x_continuous(limits=c(0, 500)) +
  scale_fill_discrete(name="Age", labels=c("20", "30", "40", "50", "60")) +
  facet_grid(. ~ AGE_GBN)


### M_CRD_SPD(월평균카드사용금액) ###

unique(data$M_CRD_SPD) #50개 유형

ggplot(data=data, aes(x=as.factor(AGE_GBN), y=M_CRD_SPD)) +
  geom_boxplot(outlier.color='red', outlier.shape=2) 
