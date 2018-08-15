#층화추출법 사용하여 데이터 나누기
library(caret)
idx <- createDataPartition(data$idx, p=0.7)
train <- data[idx$Resample1, ]
test <- data[-idx$Resample1, ]
table(train$idx)
table(test$idx)

iris

#xgboost 모형 만들기
library(xgboost)
param <- list("objective"="multi:softprob",
              "eval_metric"="mlogloss", "num_class")
x <- as.matrix(train[, 2:9])
y <- as.integer(train[,10])-1
m <- xgboost(param=param, data=x, label=y)


#######################################################
################# 결측치 대체 과정 ####################
########################################################
sh <- data2
library(mice)
md.pattern(sh)

library(VIM)
sh_plot <- aggr(sh, col=c('navyblue', 'yellow'),
                numbers=TRUE, sortVars=TRUE,
                labels=names(sh), cex.axis=.7,
                gap=3, ylab=c("Missing data", "Pattern"))

imputed_data <- mice(sh, m=5, maxit=50, method = 'pmm', seed=500)
summary(imputed_data)


summary(sh)

################## Hmisc ###########################
library(Hmisc)

#using argImpute: na값이 있는 열만 써줌
impute_arg <- aregImpute(~ RETIRE_NEED +TOT_YEA+TOT_JEOK+TOT_CHUNG+TOT_FUND +TOT_ELS_ETE, data=sh,
                         n.impute=5)
impute_arg


#check imputed variable TOT_ELS_ETE 
#각 열마다 5개의 대체값 존재, 직접 선택해야하나?
check <- impute_arg$imputed$TOT_ELS_ETE


hy <- sh[,'TOT_ELS_ETE']
hy2 <- cbind(check,hy)
hy2

############### NA값 분포 확인 #####################
sum(is.na(sh))
mean(is.na(sh))
mean(!complete.cases(sh))
############
result <- md.pattern(sh)
write.csv(result, "result.csv", row.names=TRUE) 

x <- as.data.frame(abs(is.na(sh)))
y <- x[which(apply(x,2,sum)>0)]
cor(y)

xx <- cor(y)
write.csv(xx,"xx.csv", row.names=TRUE)
xxx <- cor(sh, y, use="pairwise.complete.obs")

write.csv(xxx,"xxx.csv", row.names=TRUE)



################## mice ###########################
#만개짜리 데이터 불러오기
data<-read.csv("dataset.csv")

#개인정보 null값 처리
data<-data[is.na(data$"MARRY_Y")==FALSE,]
data[is.na(data[,'DOUBLE_IN'])==TRUE, 'DOUBLE_IN'] <- 3
data[(is.na(data[,'NUMCHILD'])==TRUE) & (data[,'DOUBLE_IN']==3), 'NUMCHILD'] <- 4
data[(is.na(data[,'NUMCHILD'])==TRUE) & (data[,'DOUBLE_IN']!=3), 'NUMCHILD'] <- 0

#원래쓰던 데이터 이름이 sh여서 sh로바꿈
sh <- data 

#mice를 이용한 결측치 대체
miceMod <- mice(sh[,!names(sh)%in%"medv"], method="rf")
mice_output <- complete(miceMod)
anyNA(mice_output)

#정확성 측정
original <- sh
actuals <- original$TOT_YEA[is.na(sh$TOT_YEA)]
predicteds <- mice_output[is.na(sh$TOT_YEA), "TOT_YEA"]
mean(actuals != predicteds)

#파일 이름 바꾸기
imputation_data <- mice_output



### MICE 다른 방법 PMM #####
mice_data <- mice(sh, maxit=50, method='pmm')
#시도했으나 RETIRE_NEEDError in solve.default(xtx + diag(pen)) : 
#system is computationally singular: reciprocal condition number = 7.04537e-17
#이런 오류뜨면서 안됨


################## missForest ########################
library(missForest)

#impute missing values, using all parameters as default values
sh.missforest <- missForest(sh)

#check imputed values
sh.missforest$ximp

#check imputation error
sh.missforest$OOBerror

#이름변경
sh_missforest <- sh.missforest
sh_mf_ximp <- sh_missforest$ximp

#comparing actual data accuracy
sh_err <- mixError(sh_missforest$ximp, sh, mice_output)
sh_err 

#csv파일로 저장
write.csv(hmisc_ip_data, "hmisc_ip_data.csv", row.names=TRUE) 
write.csv(mice_ip_data, "mice_ip_data.csv", row.names=TRUE) 
write.csv(missforeset_ip_data, "missforeset_ip_data.csv", row.names=TRUE) 

hmisc_ip_data <- imputed_data
mice_ip_data <- imputation_data
missforeset_ip_data <- sh_mf_ximp
























