getwd()
.libPaths('/home/ubuntu/R/x86_64-pc-linux-gnu-library/3.2')

data2 <- read.csv("./data2.csv")
copy <- read.csv("./copy.csv")
answer2 <- copy[,1:9]

###### 기존의 설문조사결과 결과 그룹화 ######
### 설문조사결과(1만개)를 기본정보(8개 열)로 그룹화 하여 금융정보(25개 열) 평균 계산
### 설문조사결과(1만개) 그룹화한 것을 제출용파일(14만개)에 병합(조인)
library(plyr)
library(dplyr)
temp<-group_by(data2, SEX_GBN,AGE_GBN,JOB_GBN,ADD_GBN,INCOME_GBN,MARRY_Y,DOUBLE_IN,NUMCHILD) %>% summarise_all(mean)

join_answer <- merge(temp, answer2 , by=c('SEX_GBN','AGE_GBN','JOB_GBN','ADD_GBN','INCOME_GBN','MARRY_Y','DOUBLE_IN','NUMCHILD'), all.y=TRUE)
join_answernotnull <- join_answer[is.na(join_answer[,'TOT_ASSET'])==FALSE,]

# 확인용 코드
# colnames(answer)
# colMeans(data2[data2$'SEX_GBN'==1 & data2$'AGE_GBN'==4 & data2$'JOB_GBN'==2 & data2$ADD_GBN==4 & data2$INCOME_GBN==7 & data2$MARRY_Y==2 & data2$DOUBLE_IN==2 & data2$NUMCHILD==0,])
