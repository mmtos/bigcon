############ Grouping & Merge ############
###### 기존의 설문조사결과 결과 그룹화 
###설문조사결과(1만개)를 기본정보(8개 열)로 그룹화 하여 금융정보(25개 열) 평균 계산
###설문조사결과(1만개) 그룹화한 것을 제출용파일(14만개)에 병합(조인)
library(plyr)
library(dplyr)
survey_imp <- read.csv("survey_imp.csv")
total2 <- read.csv("total2.csv")

survey_imp <- survey_imp[,2:35]
temp <- group_by(survey_imp,SEX_GBN,AGE_GBN,JOB_GBN,ADD_GBN,INCOME_GBN,MARRY_Y,DOUBLE_IN,NUMCHILD) %>% summarise_all(mean)

total2 <- total2[,2:9]
total_sparse <- merge(temp, total2 , by=c('SEX_GBN','AGE_GBN','JOB_GBN','ADD_GBN','INCOME_GBN','MARRY_Y','DOUBLE_IN','NUMCHILD'), all.y=TRUE)

summary(total_sparse)

write.csv(total_sparse, "total_sparse.csv", row.names=FALSE)
