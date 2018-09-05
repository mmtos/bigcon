################### mutate variables ################### 
rm(list=ls())

library(dplyr)

###### 1. Chararter ######
### 위험감수(Risk taking)성향 
### 1) 월 투자금(펀드/주식)(M_FUND_STOCK) / 월저축액(M_TOT_SAVING)
### 2) 금융상품잔액(TOT_FUND + TOT_ELS_ETE) / 금융자산(ASS_FIN)

total_full <- read.csv("./total_full.csv")
total_full2 <- total_full %>% mutate(M_RT_INVEST = M_FUND_STOCK/M_TOT_SAVING)
total_full2 <- total_full2 %>% mutate(TOT_RT_INVEST = (TOT_FUND + TOT_ELS_ETE)/ASS_FIN)


############ Factor Analysis ############

library(psych)
library(GPArotation)

total_cor <- round(total_full2[,-c(1:9)], 2) #exclude personal information
(cor(total_cor)>=0.8 | cor(total_cor)<=-0.8) & cor(total_cor)!=1 #check strong correlation(up to 0.8)

#ASS_FIN(11), M_TOT_SAVING(14), D_DAMBO(24) : strong correlation

#TOT_ASSET(10), M_TOT_SAVING(14), CHUNG_Y(16), M_FUND_STOCK(17), TOT_DEBT(22)
total_factor <- total_full2[,-c(1:9,11,14,24,10,14,16,17,22)]

### Number of factors
# show the maximum number of factors
fa.parallel(total_factor, fm='wls', fa='fa')
#Factor Analysis
fit.fa <- fa(total_factor, nfactors=7, rotate="oblimin", fm="wls")
print(fit.fa) #RMSR:0.02, TLI:0.586, RMSEA:0.209
print(fit.fa$loadings, cutoff=0.4, sort=T) #요인적재량(변수와 요인간의 관계 정도)>0.4 :유의(보수적)
fa.diagram(fit.fa)

##############################################################################
###### except1 #####
#D_JEONSEA(26), M_CRD_SPD(35)
total_factor <- total_full2[,-c(1:9,11,14,24,10,14,16,17,22,26,35)]
### Number of factors
# show the maximum number of factors
fa.parallel(total_factor, fm='wls', fa='fa')
#Factor Analysis
fit.fa <- fa(total_factor, nfactors=6, rotate="oblimin", fm="wls")
print(fit.fa) #RMSR:0.01, TLI:0.928, RMSEA:0.074
print(fit.fa$loadings, cutoff=0.4, sort=T) #요인적재량(변수와 요인간의 관계 정도)>0.4 :유의(보수적)
fa.diagram(fit.fa)

##############################################################################
###### except2 #####
#D_SHINYOUNG(23)
total_factor <- total_full2[,-c(1:9,11,14,24,10,14,16,17,22,26,35,23)]
### Number of factors
# show the maximum number of factors
fa.parallel(total_factor, fm='wls', fa='fa')
#Factor Analysis
fit.fa <- fa(total_factor, nfactors=6, rotate="oblimin", fm="wls")
print(fit.fa) #RMSR:0.01, TLI:0.943, RMSEA:0.069
print(fit.fa$loadings, cutoff=0.4, sort=T) #요인적재량(변수와 요인간의 관계 정도)>0.4 :유의(보수적)
fa.diagram(fit.fa)

##############################################################################
###### except3 #####
#RETIRE_NEED(27)
total_factor <- total_full2[,-c(1:9,11,14,24,10,14,16,17,22,26,35,23,27)]
### Number of factors
# show the maximum number of factors
fa.parallel(total_factor, fm='wls', fa='fa')
#Factor Analysis
fit.fa <- fa(total_factor, nfactors=6, rotate="oblimin", fm="wls")
fa.diagram(fit.fa)
print(fit.fa) #RMSR:0.01, TLI:0.955, RMSEA:0.062

##############################################################################
###### except4 #####
#TOT_SOBI(34)
total_factor <- total_full2[,-c(1:9,11,14,24,10,14,16,17,22,26,35,23,27,34)]
### Number of factors
# show the maximum number of factors
fa.parallel(total_factor, fm='wls', fa='fa')
#Factor Analysis
fit.fa <- fa(total_factor, nfactors=5, rotate="oblimin", fm="wls")
print(fit.fa) #RMSR: 0.01 , TLI:0.96, RMSEA:0.059
print(fit.fa$loadings, cutoff=0.3, sort=T) #요인적재량(변수와 요인간의 관계 정도)>0.4 :유의(보수적)
fa.diagram(fit.fa)

#Factor Analysis
fit.fa <- fa(total_factor, nfactors=4, rotate="oblimin", fm="wls")
print(fit.fa) #RMSR: 0.02 , TLI:0.924, RMSEA:0.081
print(fit.fa$loadings, cutoff=0.3, sort=T) #요인적재량(변수와 요인간의 관계 정도)>0.4 :유의(보수적)
fa.diagram(fit.fa)


##############################################################################

#extract factor
factor <- as.data.frame(fit.fa$scores)
total_factor <- cbind(total_full[,1:9], factor)


#make total_factor csv file
write.csv(total_factor, "./total_factor.csv", row.names=FALSE)
