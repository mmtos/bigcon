#사용 방법(패키지): missForest
#- 사용된 알고리즘: random forest
#랜덤포레스트 알고리즘은 비매개변수 method로서, 함수에 대해 특정한 추정을 하지 않는다. 대신
#각 데이터값에 근접하게 추정하는 방식으로 랜덤포레스트 모델을 만들어 결측치를 추정하는 방식이다.
#Non-parametric method does not make explicit assumptions about functional form
#of f (any arbitary function). Instead, it tries to estimate f such that it can be as close to the
#data points without seeming impractical.     

missForest.R

############ missForest ############

library(missForest)
survey2 <- read.csv("./survey2.csv")

#impute missing values, using all parameters as default values
survey2.missforest <- missForest(survey2)

#check imputed values
survey2.missforest$ximp

#check imputation error
#NRMAS: normalized mean squared error

survey2.missforest$OOBerror

#결측치 대체한 테이블 저장
survey_imp <- survey2.missforest$ximp
write.csv(survey_imp, "survey_imp.csv", row.names=FALSE)

data <- read.csv("missForest_imp_data.csv")
View(data)
