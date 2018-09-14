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

################################################### end of task1 : create full dataset
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

############ Clustering ############
rm(list=ls())

total_factor <- read.csv('./total_factor.csv')

total_factor$MARRY_Y[is.na(total_factor$MARRY_Y)==TRUE]<-0

###### Grouping ######
#create segments : sex, age, job, marry
#grouping sex=1:2, age=2:6, job=2:11, marry=0:2
#group 1-90 : grouping by MARRY_Y==0
## group1~5
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==2 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i-1,'.csv'),row.names = FALSE)
}
## group6~10
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==3 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+4,'.csv'),row.names = FALSE)
}
## group11~15
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==4 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+9,'.csv'),row.names = FALSE)
}
## group106~110
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==6 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+14,'.csv'),row.names = FALSE)
}
## group111~115
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==7 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+19,'.csv'),row.names = FALSE)
}
## group116~120
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==8 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+24,'.csv'),row.names = FALSE)
}
## group121~125
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==9 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+29,'.csv'),row.names = FALSE)
}
## group126~130
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==10 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+34,'.csv'),row.names = FALSE)
}
## group131~135
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==11 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+39,'.csv'),row.names = FALSE)
}
## group136~140
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==2 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+44,'.csv'),row.names = FALSE)
}
## group141~145
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==3 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+49,'.csv'),row.names = FALSE)
}
## group146~150
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==4 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+54,'.csv'),row.names = FALSE)
}
## group151~155
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==6 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+59,'.csv'),row.names = FALSE)
}
## group156~160
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==7 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+64,'.csv'),row.names = FALSE)
}
## group161~165
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==8 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+69,'.csv'),row.names = FALSE)
}
## group166~170
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==9 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+74,'.csv'),row.names = FALSE)
}
## group171~175
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==10 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+79,'.csv'),row.names = FALSE)
}
## group176~180
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==11 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+84,'.csv'),row.names = FALSE)
}
 
#group 91-180 : grouping by MARRY_Y==1
## group91~95
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==2 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+89,'.csv'),row.names = FALSE)
}
## group96~100
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==3 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+94,'.csv'),row.names = FALSE)
}
## group101~105
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==4 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+99,'.csv'),row.names = FALSE)
}
## group106~110
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==6 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+104,'.csv'),row.names = FALSE)
}
## group111~115
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==7 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+109,'.csv'),row.names = FALSE)
}
## group116~120
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==8 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+114,'.csv'),row.names = FALSE)
}
## group121~125
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==9 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+119,'.csv'),row.names = FALSE)
}
## group126~130
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==10 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+124,'.csv'),row.names = FALSE)
}
## group131~135
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==11 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+129,'.csv'),row.names = FALSE)
}
## group136~140
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==2 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+134,'.csv'),row.names = FALSE)
}
## group141~145
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==3 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+139,'.csv'),row.names = FALSE)
}
## group146~150
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==4 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+144,'.csv'),row.names = FALSE)
}
## group151~155
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==6 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+149,'.csv'),row.names = FALSE)
}
## group156~160
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==7 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+154,'.csv'),row.names = FALSE)
}
## group161~165
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==8 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+159,'.csv'),row.names = FALSE)
}
## group166~170
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==9 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+164,'.csv'),row.names = FALSE)
}
## group171~175
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==10 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+169,'.csv'),row.names = FALSE)
}
## group176~180
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==11 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+174,'.csv'),row.names = FALSE)
}

#group 181-270 : grouping by MARRY_Y==2
## group181~185
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==2 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+179,'.csv'),row.names = FALSE)
}
## group186~190
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==3 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+184,'.csv'),row.names = FALSE)
}
## group191~195
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==4 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+189,'.csv'),row.names = FALSE)
}
## group196~200
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==6 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+194,'.csv'),row.names = FALSE)
}
## group201~205
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==7 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+199,'.csv'),row.names = FALSE)
}
## group206~210
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==8 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+204,'.csv'),row.names = FALSE)
}
## group211~215
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==9 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+209,'.csv'),row.names = FALSE)
}
## group216~220
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==10 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+214,'.csv'),row.names = FALSE)
}
## group221~225
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==11 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+219,'.csv'),row.names = FALSE)
}
## group226~230
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==2 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+224,'.csv'),row.names = FALSE)
}
## group231~235
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==3 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+229,'.csv'),row.names = FALSE)
}
## group236~240
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==4 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+234,'.csv'),row.names = FALSE)
}
## group241~245
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==6 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+239,'.csv'),row.names = FALSE)
}
## group246~250
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==7 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+244,'.csv'),row.names = FALSE)
}
## group251~255
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==8 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+249,'.csv'),row.names = FALSE)
}
## group256~260
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==9 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+254,'.csv'),row.names = FALSE)
}
## group261~265
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==10 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+259,'.csv'),row.names = FALSE)
}
## group266~270
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==11 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+264,'.csv'),row.names = FALSE)
}

###### Nbclust : determining the best number of clusters in each group loading csv file ######
for (i in 1:270){
  group<-read.csv(paste0('./group',i,'.csv'))
  total_scale<-scale(group[,10:13])
  total_scale<-as.data.frame(total_scale)
  assign(paste0('nc',i),NbClust(total_scale, min.nc=3, max.nc=10, method="kmeans"))
}

###### Kmeans ######
nbc <- c(4,4,3,4,4,4,4,4,4,4,
         4,3,4,4,9,4,4,4,4,3,
         4,4,3,4,3,3,4,3,3,3,
         3,4,8,4,3,3,3,3,4,4,
         3,3,3,3,3,4,3,4,4,4,
         4,3,3,4,3,4,4,4,4,3,
         4,4,3,4,3,4,4,3,3,3,
         4,4,4,6,7,5,4,3,3,5,
         3,4,4,4,5,3,4,4,4,3,
         4,3,4,3,3,4,3,3,9,3,
         4,4,3,4,3,4,4,3,4,3,
         3,4,4,5,6,3,4,7,4,3,
         3,4,3,4,4,3,4,3,4,3,
         3,3,7,4,3,4,3,4,4,3,
         4,3,3,4,4,4,4,4,4,3,
         3,4,3,4,3,3,4,4,4,3,
         3,3,3,4,3,4,4,3,4,3,
         3,3,3,4,4,4,3,3,4,4,
         4,4,4,3,4,4,4,3,4,4,
         4,4,4,4,4,4,4,4,4,4,
         4,4,3,3,7,3,4,3,3,3,
         4,3,3,3,4,3,3,3,4,4,
         3,3,3,3,3,4,3,4,3,4,
         4,4,4,4,4,4,4,4,4,4,
         4,4,4,4,4,4,4,3,3,4,
         4,4,3,6,5,4,4,3,4,5,
         3,4,4,4,5,3,4,4,4,3)

for ( i in 1:270){
  group<-read.csv(paste0('./group',i,'.csv'))
  total_scale<-scale(group)
  total_scale<-as.data.frame(total_scale)

  group_head <- group[,1:9]
  group <- group[,10:13]
  
  #scaling for clustering
  total_scale <- scale(group)
  total_scale <- as.data.frame(total_scale)
  #kmeans 
  group_k <- kmeans(group,nbc[i])
  group <- cbind(group_head,group,group_k$cluster)
  
  if (i >= 2){
    if(nbc[i]==3){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
    }else if(nbc[i]==4){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
      group$`group_k$cluster`[group$`group_k$cluster`==4]<-sum(nbc[1:(i-1)])+4
    }else if(nbc[i]==5){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
      group$`group_k$cluster`[group$`group_k$cluster`==4]<-sum(nbc[1:(i-1)])+4
      group$`group_k$cluster`[group$`group_k$cluster`==5]<-sum(nbc[1:(i-1)])+5
    }else if(nbc[i]==6){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
      group$`group_k$cluster`[group$`group_k$cluster`==4]<-sum(nbc[1:(i-1)])+4
      group$`group_k$cluster`[group$`group_k$cluster`==5]<-sum(nbc[1:(i-1)])+5
      group$`group_k$cluster`[group$`group_k$cluster`==6]<-sum(nbc[1:(i-1)])+6
    }else if(nbc[i]==7){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
      group$`group_k$cluster`[group$`group_k$cluster`==4]<-sum(nbc[1:(i-1)])+4
      group$`group_k$cluster`[group$`group_k$cluster`==5]<-sum(nbc[1:(i-1)])+5
      group$`group_k$cluster`[group$`group_k$cluster`==6]<-sum(nbc[1:(i-1)])+6
      group$`group_k$cluster`[group$`group_k$cluster`==7]<-sum(nbc[1:(i-1)])+7
    }else if(nbc[i]==8){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
      group$`group_k$cluster`[group$`group_k$cluster`==4]<-sum(nbc[1:(i-1)])+4
      group$`group_k$cluster`[group$`group_k$cluster`==5]<-sum(nbc[1:(i-1)])+5
      group$`group_k$cluster`[group$`group_k$cluster`==6]<-sum(nbc[1:(i-1)])+6
      group$`group_k$cluster`[group$`group_k$cluster`==7]<-sum(nbc[1:(i-1)])+7
      group$`group_k$cluster`[group$`group_k$cluster`==8]<-sum(nbc[1:(i-1)])+8
    }else if(nbc[i]==9){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
      group$`group_k$cluster`[group$`group_k$cluster`==4]<-sum(nbc[1:(i-1)])+4
      group$`group_k$cluster`[group$`group_k$cluster`==5]<-sum(nbc[1:(i-1)])+5
      group$`group_k$cluster`[group$`group_k$cluster`==6]<-sum(nbc[1:(i-1)])+6
      group$`group_k$cluster`[group$`group_k$cluster`==7]<-sum(nbc[1:(i-1)])+7
      group$`group_k$cluster`[group$`group_k$cluster`==8]<-sum(nbc[1:(i-1)])+8
      group$`group_k$cluster`[group$`group_k$cluster`==9]<-sum(nbc[1:(i-1)])+9
    }
  }
  write.csv(group,paste0('./group',i,'_k.csv'),row.names = FALSE)
}

for (i in 3:270){
  aa <- read.csv(paste0('./group',i,'_k.csv'))
  group <- rbind(group,aa)
}
group_kmeans <- group[order(group$PEER_NO),]
write.csv(group_kmeans,'./total_cluster.csv',row.names = FALSE)

total_cluster <- read.csv('./total_cluster.csv')
peer_group <- total_cluster[,c(1,14)] #including only peer no. and cluster no.
write.csv(peer_group,'./peer_group.csv',row.names = FALSE) #answer of task2

################################################### end of task2 : mapping from customer type to peer group
############ Percentile ############
#cbind financial info and cluster no.
total_cluster <- read.csv('./total_cluster.csv')
total_full <- read.csv('./total_full.csv')

total_cluster_cbind <- cbind(total_full,total_cluster$group_k.cluster)

#including only "ASS_FIN","M_TOT_SAVING","TOT_SOBI","CLUSTER"
total_cluster_cbind <- total_cluster_cbind[,c(11,14,34,36)]
colnames(total_cluster_cbind) <- c("ASS_FIN","M_TOT_SAVING","TOT_SOBI","CLUSTER")

#grouping by cluster no.
#firstly, create qor_all group which cluster no. is 1 : the main table for adding the results which can get "for loop"
total_cluster_cbind_1 <- total_cluster_cbind[total_cluster_cbind$CLUSTER==1,]  
#percentiles for each column
ASS_FIN <- quantile(total_cluster_cbind_1[,1],seq(0,1,0.01))
M_TOT_SAVING <- quantile(total_cluster_cbind_n[,2],seq(0,1,0.01))
TOT_SOBI < -quantile(total_cluster_cbind_n[,3],seq(0,1,0.01))
#rbind and save data in "qor_all" variable
qor_all <- rbind(ASS_FIN,M_TOT_SAVING,TOT_SOBI)

#using for loop from 2nd to 1015th cluster.
for (i in 2:1015){
  total_cluster_cbind_n<-total_cluster_cbind[total_cluster_cbind$CLUSTER==i,]
  ASS_FIN<-quantile(total_cluster_cbind_n[,1],seq(0,1,0.01))
  M_TOT_SAVING<-quantile(total_cluster_cbind_n[,2],seq(0,1,0.01))
  TOT_SOBI<-quantile(total_cluster_cbind_n[,3],seq(0,1,0.01))
  qor<-rbind(ASS_FIN,M_TOT_SAVING,TOT_SOBI)
  qor_all<-rbind(qor_all,qor)
}

qor_all < -as.data.frame(qor_all)

#rename row names for answer sheet
rownames(qor_all) < -seq(1:3045)
PEER_GROUP_No < -rep(1:1015,each=3)
COLUMN_NAME <- rep(c('금융자산','월저축금액','월소비금액'),1015)
qor_all <- cbind(PEER_GROUP_No,COLUMN_NAME,qor_all)

write.csv(qor_all,'./total_pecentile.csv',row.names = FALSE) #answer of task3
################################################### end of task3 : amount distribution by peer group
