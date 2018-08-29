############ Preprocessing Missing Value ############
######1. load survey data
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


######2. load answer sheet
total <- read.csv("./total.csv")

#level sync with survey
total[is.na(total[,'DOUBLE_IN'])==TRUE,'DOUBLE_IN'] <-3
total[is.na(total[,'NUMCHILD'])==TRUE,'NUMCHILD'] <-4
total[(is.na(total[,'MARRY_Y'])==TRUE) & (total[,'DOUBLE_IN']==3),'MARRY_Y'] <-1
total[(is.na(total[,'MARRY_Y'])==TRUE) & (total[,'DOUBLE_IN']!=3),'MARRY_Y'] <-2

#save
write.csv(total,file="total2.csv",row.names = FALSE)
