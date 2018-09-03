rm(list=ls())

library(xgboost)

survey <- read.csv("./survey_imp.csv")
total <- read.csv("./total2.csv")

temp <- survey[,10:35]
temp[temp==0] <- 1
survey <- cbind(survey[,1:9],temp)

#data 분할
train <- survey[sample(nrow(survey), nrow(survey)*0.8),]
eval <- survey[survey$idx %in% train$idx == FALSE,]

#regressor 
feature <- colnames(train)
(feature <- feature[c(2:9)])

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
check('M_CRD_SPD')

xgreg('RETIRE_NEED')
check('RETIRE_NEED')

xgreg('TOT_SOBI')
check('TOT_SOBI')

xgreg('ASS_REAL')
check('ASS_REAL')

xgreg('ASS_FIN')
check('ASS_FIN')

xgreg('ASS_ETC')
check('ASS_ETC')

total['TOT_ASSET'] <- total['ASS_REAL']+total['ASS_FIN']+total['ASS_ETC']
check('TOT_ASSET')

xgreg('M_TOT_SAVING')
check('M_TOT_SAVING')

xgreg('FOR_RETIRE')
check('FOR_RETIRE')

xgreg('M_SAVING_INSUR')
check('M_SAVING_INSUR')

xgreg('M_JEOK')
check('M_JEOK')

xgreg('TOT_JEOK')
check('TOT_JEOK')

xgreg('D_SHINYONG')
check('D_SHINYONG')

xgreg('TOT_YEA')
check('TOT_YEA')

xgreg('D_DAMBO')
check('D_DAMBO')

xgreg('D_JUTEAKDAMBO')
check('D_JUTEAKDAMBO')

xgreg('TOT_DEBT')
check('TOT_DEBT')

xgreg('D_JEONSEA')
check('D_JEONSEA')

xgreg('TOT_FUND')
check('TOT_FUND')

xgreg('M_FUND')
check('M_FUND')

xgreg('M_STOCK')
check('M_STOCK')

total['M_FUND_STOCK'] <- total['M_FUND']+total['M_STOCK']
check('M_FUND_STOCK')

xgreg('TOT_CHUNG')
check('TOT_CHUNG')

xgreg('M_CHUNG')
check('M_CHUNG')

xgreg('TOT_ELS_ETE')
check('TOT_ELS_ETE')

xgreg('TOT_ELS_ETE')
check('TOT_ELS_ETE')

colnames(survey)
summary(survey['CHUNG_Y'])

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
summary(total)
total['M_SAVING.INSUR'] <-NULL

# make total_full
total2 <- round(total, 2)
temp <- total2[,-c(20:34)]
total_full <- cbind(temp, total2[,c(20:34)])

origin <- read.csv("./total.csv")
total_full2 <- cbind(origin[1:9],total_full[10:35])

write.csv(total_full2, file="total_full.csv", row.names=FALSE) #answer of task1
