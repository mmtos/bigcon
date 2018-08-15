#사용 방법(패키지): missForest
#- 사용된 알고리즘: random forest
#랜덤포레스트 알고리즘은 비매개변수 method로서, 함수에 대해 특정한 추정을 하지 않는다. 대신
#각 데이터값에 근접하게 추정하는 방식으로 랜덤포레스트 모델을 만들어 결측치를 추정하는 방식이다.
#Non-parametric method does not make explicit assumptions about functional form
#of f (any arbitary function). Instead, it tries to estimate f such that it can be as close to the
#data points without seeming impractical.     

missForest.R

### DATA 테이블 처리 ###
#만개짜리 데이터 불러오기
data<-read.csv("./data2.csv")

#원래쓰던 데이터 이름이 sh여서 sh로바꿈
sh <- data 


################## missForest ########################
library(missForest)

#impute missing values, using all parameters as default values
sh.missforest <- missForest(sh)

#check imputed values
sh.missforest$ximp

#check imputation error
#NRMAS: normalized mean squared error
sh.missforest$OOBerror

#결측치 대체한 테이블 저장
sh_mf_imp <- sh.missforest$ximp
write.csv(sh_mf_imp, "missForest_imp_data.csv", row.names=FALSE)