mice(random_forest).R 


### DATA 테이블 처리 ###
#만개짜리 데이터 불러오기
data<-read.csv("./data2.csv")

#원래쓰던 데이터 이름이 sh여서 sh로바꿈
sh <- data

#library load
library(mice)
library(randomForest)

#mice를 이용한 결측치 대체
#랜덤포레스트를 이용해 mice imputation 
miceMod <- mice(sh[,!names(sh)%in%"medv"], method="rf")

#여러개 추정된 데이터를 하나로 합침
mice_output <- complete(miceMod)

#결측치 있는 지 확인
anyNA(mice_output)

#정확성 측정
original <- sh
actuals <- original$TOT_YEA[is.na(sh$TOT_YEA)]
predicteds <- mice_output[is.na(sh$TOT_YEA), "TOT_YEA"]
mean(actuals != predicteds)

#csv 파일로 저장
write.csv(mice_output, "mice_imp_data.csv", row.names=FALSE)