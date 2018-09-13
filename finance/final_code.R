############ Preprocessing Missing Value ############
###### change the factor level ######
#1. load survey data
survey <- read.csv("./survey.csv")

#level sync with total
survey[is.na(survey[,'DOUBLE_IN'])==TRUE,'DOUBLE_IN'] <-3
survey[(is.na(survey[,'NUMCHILD'])==TRUE) & (survey[,'DOUBLE_IN']==3),'NUMCHILD'] <-4
survey[(is.na(survey[,'NUMCHILD'])==TRUE) & (survey[,'DOUBLE_IN']!=3),'NUMCHILD'] <-0

#preprocessing before MissForest
survey[(is.na(survey[,'CHUNG_Y'])==TRUE),'TOT_CHUNG'] <-0
survey[(is.na(survey[,'CHUNG_Y'])==TRUE) & (survey[,'TOT_CHUNG']==0),'CHUNG_Y'] <-0
survey[(is.na(survey[,'RETIRE_NEED'])==TRUE) & (survey[,'AGE_GBN']==2),'RETIRE_NEED'] <-0
survey[(is.na(survey[,'RETIRE_NEED'])==TRUE) & (survey[,'AGE_GBN']==3),'RETIRE_NEED'] <-0

#save
write.csv(survey,file="survey2.csv",row.names = FALSE)


#2. load answer sheet
total <- read.csv("./total.csv")

#level sync with survey
total[is.na(total[,'DOUBLE_IN'])==TRUE,'DOUBLE_IN'] <-3
total[is.na(total[,'NUMCHILD'])==TRUE,'NUMCHILD'] <-4
total[(is.na(total[,'MARRY_Y'])==TRUE) & (total[,'DOUBLE_IN']==3),'MARRY_Y'] <-1
total[(is.na(total[,'MARRY_Y'])==TRUE) & (total[,'DOUBLE_IN']!=3),'MARRY_Y'] <-2

#save
write.csv(total,file="total2.csv",row.names = FALSE)


############ impute missing values in survey data : missForest ############
rm(list=ls())

library(missForest)
survey2 <- read.csv("./survey2.csv")

#impute missing values, using all parameters as default values
survey2.missforest <- missForest(survey2)

#check imputed values
survey2.missforest$ximp

#check imputation error
#NRMAS: normalized mean squared error

survey2.missforest$OOBerror

#save
survey_imp <- survey2.missforest$ximp
write.csv(survey_imp, "survey_imp.csv", row.names=FALSE)

data <- read.csv("missForest_imp_data.csv")


############ impute missing values in total data : xgboost ############
rm(list=ls())

library(xgboost)

survey <- read.csv("./survey_imp.csv")
total <- read.csv("./total2.csv")

temp <- survey[,10:35]
temp[temp==0] <- 1
survey <- cbind(survey[,1:9],temp)

#split data : train data and evaluating data
train <- survey[sample(nrow(survey), nrow(survey)*0.8),]
eval <- survey[survey$idx %in% train$idx == FALSE,]

#regressor 
feature <- colnames(train)
feature <- feature[c(2:9)]

xgreg <- function(dependant){
  print('independant variable list : ')
  print(feature)
  print('dependant variable :')
  print(dependant)
  
  X_train <- train[feature]
  y_train <- log(train[dependant])
  X_eval <- eval[feature]
  y_eval <- log(eval[dependant])
  dtrain <- xgb.DMatrix(data=as.matrix(X_train), label=as.matrix(y_train))
  evalset <- xgb.DMatrix(data=as.matrix(X_eval), label=as.matrix(y_eval))
  watch <- list(train=dtrain,eval=evalset)
  params <- list(objective='reg:linear',
               eval_metric='rmse'
              )
  model <- xgb.train(params,
                     dtrain,
                     nrounds=3000,
                     watchlist=watch,
                     early_stopping_rounds=50,
                     print_every_n=50L,
                     maximize=FALSE
                     )
  print("best_iter :")
  print(model$best_iteration)
  print("best_score :")
  print(model$best_score)

    #fill total table
  X_total <- total[feature]
  pred_y_total <- predict(model,as.matrix(X_total))
  total[dependant] <<- exp(pred_y_total)
  feature <<- c(feature,dependant)
}
check <- function(dependant){
  print(summary(total[dependant]))
  print(summary(survey[dependant]))
  print(feature)
}

xgreg('M_CRD_SPD')
xgreg('RETIRE_NEED')

xgreg('TOT_SOBI')
xgreg('ASS_REAL')
xgreg('ASS_FIN')
xgreg('ASS_ETC')

total['TOT_ASSET'] <- total['ASS_REAL']+total['ASS_FIN']+total['ASS_ETC']

xgreg('M_TOT_SAVING')
xgreg('FOR_RETIRE')
xgreg('M_SAVING_INSUR')
xgreg('M_JEOK')
xgreg('TOT_JEOK')
xgreg('D_SHINYONG')
xgreg('TOT_YEA')
xgreg('D_DAMBO')
xgreg('D_JUTEAKDAMBO')
xgreg('TOT_DEBT')
xgreg('D_JEONSEA')
xgreg('TOT_FUND')
xgreg('M_FUND')
xgreg('M_STOCK')

total['M_FUND_STOCK'] <- total['M_FUND']+total['M_STOCK']

xgreg('TOT_CHUNG')
xgreg('M_CHUNG')
xgreg('TOT_ELS_ETE')

xgcls <- function(dependant){
  print('independant variable list : ')
  print(feature)
  print('dependant variable :')
  print(dependant)
  
  X_train <- train[feature]
  y_train <- train[dependant]
  X_eval <- eval[feature]
  y_eval <- eval[dependant]
  dtrain <- xgb.DMatrix(data=as.matrix(X_train), label=as.matrix(y_train))
  evalset <- xgb.DMatrix(data=as.matrix(X_eval), label=as.matrix(y_eval))
  watch <- list(train=dtrain, eval=evalset)
  params <-list(objective='binary:logistic'
  )
  model <- xgb.train(params,
                     dtrain,
                     nrounds=3000,
                     watchlist=watch,
                     early_stopping_rounds=50,
                     print_every_n=50L,
                     maximize=FALSE
  )
  print("best_iter :")
  print(model$best_iteration)
  print("best_score :")
  print(model$best_score)
  
  #fill total table
  X_total <- total[feature]
  pred_y_total <- predict(model, as.matrix(X_total))
  total[dependant] <<- pred_y_total
  feature <<- c(feature, dependant)
}
train[train['CHUNG_Y']==1, 'CHUNG_Y'] <-0
train[train['CHUNG_Y']==5, 'CHUNG_Y'] <-1
eval[eval['CHUNG_Y']==1, 'CHUNG_Y'] <-0
eval[eval['CHUNG_Y']==5, 'CHUNG_Y'] <-1

xgcls('CHUNG_Y')
total[total['CHUNG_Y']<=0.5,'CHUNG_Y'] <-0
total[total['CHUNG_Y']>=0.5,'CHUNG_Y'] <-5

total['M_SAVING.INSUR']<-NULL

# make total_full
total2 <- round(total, 2)
temp <- total2[,-c(20:34)]
total_full <- cbind(temp, total2[,c(20:34)])

origin <- read.csv("./total.csv")
total_full2 <- cbind(origin[1:9],total_full[10:35])

write.csv(total_full2, file="total_full.csv", row.names=FALSE) #answer of task1

###################################################
############ mutate variables ############ 
rm(list=ls())

library(dplyr)

###### Chararter ######
### Risk taking
### 1) M_FUND_STOCK / M_TOT_SAVING
### 2) (TOT_FUND + TOT_ELS_ETE) / ASS_FIN

total_full <- read.csv("./total_full.csv")
total_full2 <- total_full %>% mutate(M_RT_INVEST = M_FUND_STOCK/M_TOT_SAVING)
total_full2 <- total_full2 %>% mutate(TOT_RT_INVEST = (TOT_FUND + TOT_ELS_ETE)/ASS_FIN)


############ Factor Analysis ############

library(psych)
library(GPArotation)

total_cor <- round(total_full2[,-c(1:9)], 2) #exclude personal information
(cor(total_cor)>=0.8 | cor(total_cor)<=-0.8) & cor(total_cor)!=1 #check strong correlation(up to 0.8)

#ASS_FIN(11), M_TOT_SAVING(14), D_DAMBO(24) : strong correlation with more than 3 variables
#TOT_ASSET(10), M_TOT_SAVING(14), CHUNG_Y(16), M_FUND_STOCK(17), TOT_DEBT(22)

#factor analysis according to criteria
total_factor <- total_full2[,-c(1:9,11,14,24,10,14,16,17,22,26,35,23,27,34,19)]

#Number of factors : show the maximum number of factors
fa.parallel(total_factor, fm='wls', fa='fa')

#Factor Analysis
fit.fa <- fa(total_factor, nfactors=4, rotate="oblimin", fm="wls")
print(fit.fa) #RMSR:0.02, TLI:0.924, RMSEA:0.081
print(fit.fa$loadings, cutoff=0.4, sort=T) #factor loadings between variables and factors>0.4
fa.diagram(fit.fa)

#extract factor
factor <- as.data.frame(fit.fa$scores)
total_factor <- cbind(total_full[,1:9], factor)

#save
write.csv(total_factor, "./total_factor.csv", row.names=FALSE)

