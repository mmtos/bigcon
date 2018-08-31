getwd()
.libPaths('/home/ubuntu/R/x86_64-pc-linux-gnu-library/3.2')
data2 <- read.csv("./Data2.csv")
cols<-colnames(data2)
depvari <- cols[-c(1:9)]
indvari <- cols[c(2:9)]


data2[is.na(data2)]<-1
zerotoone <- function(df,colname){
  for(col in colname){
    print(col)
    df[df[,col]==0,col]<-1
    
  }
  return (df)
}
data2<-zerotoone(data2,cols)


### prediction 순서 1~24번(ACC_ETC,CHUNG_Y,M_STOCK 제외) ###
model<-'log10(df[,col]) ~ factor(SEX_GBN) + factor(AGE_GBN) + factor(JOB_GBN) + factor(ADD_GBN) + factor(INCOME_GBN)+ factor(MARRY_Y) + factor(DOUBLE_IN) + factor(NUMCHILD)'

ols <- function(df,depens,model){
  model <- as.formula(model)
  for(col in depens){
    m <- lm(model, data=df)
    m.r <- summary(m)$r.squared
    m.adr <-summary(m)$adj.r.squared
    print(col)  
    print(m.r)
    print(m.adr)
  }
}
ols(data2,depvari,model)

#1. M_CRD_SPD  선정
excludevari<-function(model,exvar){
  remove<<- c(exvar)
  depvari<<-setdiff(depvari,remove)
  exvar<-paste('+',exvar)
  model<<- paste(model,exvar)
}
excludevari(model,'M_CRD_SPD')
ols(data2,depvari,model)

#2. RETIRE_NEED 
excludevari(model,'RETIRE_NEED')
ols(data2,depvari,model)

#3. TOT_SOBI 
excludevari(model,'TOT_SOBI')
ols(data2,depvari,model)

#ASSET 다중공선성 처리(TOT, FIN,REAL 3개만 예측하고 나머진 계산하는걸로)
#4. TOT_ASSET
excludevari(model,'TOT_ASSET')
ols(data2,depvari,model)

#5. ASS_REAL 
excludevari(model,'ASS_REAL')
ols(data2,depvari,model)

#6. ASS_FIN 
excludevari(model,'ASS_FIN')
ols(data2,depvari,model)

#7. M_TOT_SAVING 
excludevari(model,'M_TOT_SAVING')
ols(data2,depvari,model)

#8. FOR_RETIRE 
excludevari(model,'FOR_RETIRE')
ols(data2,depvari,model)

#9. M_SAVING_INSUR 
excludevari(model,'M_SAVING_INSUR')
ols(data2,depvari,model)

#10. M_JEOK 
excludevari(model,'M_JEOK')
ols(data2,depvari,model)

#11. TOT_JEOK 
excludevari(model,'TOT_JEOK')
ols(data2,depvari,model)

#12.D_SHINYONG 
excludevari(model,'D_SHINYONG')
ols(data2,depvari,model)

#13. TOT_YEA 
excludevari(model,'TOT_YEA')
ols(data2,depvari,model)

#14. D_DAMBO 
excludevari(model,'D_DAMBO')
ols(data2,depvari,model)

#15. D_JUTEAKDAMBO 
excludevari(model,'D_JUTEAKDAMBO')
ols(data2,depvari,model)

#16.TOT_DEBT 
excludevari(model,'TOT_DEBT')
ols(data2,depvari,model)

#17. D_JEONSEA  
excludevari(model,'D_JEONSEA')
ols(data2,depvari,model)

#18. TOT_FUND 
excludevari(model,'TOT_FUND')
ols(data2,depvari,model)

#19. M_FUND 
excludevari(model,'M_FUND')
ols(data2,depvari,model)

#20. M_FUND_STOCK  (M_STOCK 은 생략)
excludevari(model,'M_FUND_STOCK')
ols(data2,depvari,model)

#21. TOT_CHUNG 
excludevari(model,'TOT_CHUNG')
ols(data2,depvari,model)

#22. M_CHUNG
excludevari(model,'M_CHUNG')
ols(data2,depvari,model)

#23. CHUNG_Y는 TOT_CHUNG이 1이 아닌경우 5, 1인경우 1로 함
temp<-data2[data2[,'CHUNG_Y']==1,c('M_CHUNG','CHUNG_Y','TOT_CHUNG')]
temp<-data2[data2[,'TOT_CHUNG']!=1,c('M_CHUNG','CHUNG_Y','TOT_CHUNG')]
temp<-survey[(is.na(survey[,'CHUNG_Y'])==TRUE),c('CHUNG_Y','TOT_CHUNG')]
survey[(is.na(survey[,'CHUNG_Y'])==TRUE) & (survey[,'TOT_CHUNG']!=0),'CHUNG_Y'] <-5
survey[(is.na(survey[,'CHUNG_Y'])==TRUE) & (survey[,'TOT_CHUNG']==0),'CHUNG_Y'] <-0

#24. TOT_ELS_ETE
