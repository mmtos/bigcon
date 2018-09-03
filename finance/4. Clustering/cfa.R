
################### mutate variables ################### 
rm(list=ls())

library(dplyr)

###### 1. Chararter ######
### 위험감수(Risk taking)성향 
### 1) 월 투자금(펀드/주식)(M_FUND_STOCK) / 월저축액(M_TOT_SAVING)
### 2) 금융상품잔액(TOT_FUND + TOT_ELS_ETE) / 금융자산(ASS_FIN)

total_full <- read.csv("./total_full.csv") #same as total_full table, but change na to number
total_full2 <- total_full %>% mutate(M_RT_INVEST = M_FUND_STOCK/M_TOT_SAVING)
total_full2 <- total_full2 %>% mutate(TOT_RT_INVEST = (TOT_FUND + TOT_ELS_ETE)/ASS_FIN)


############ Factor Analysis ############
rm(list=ls())

library(psych)
library(GPArotation)

total_cor <- round(total_full2[,-c(1:9)], 2) #기본정보 제외
(cor(total_cor)>=0.8 | cor(total_cor)<=-0.8) & cor(total_cor)!=1 #check strong correlation(up to 0.8)

total_factor <- total_full2[,-c(1:9,10:11,12,14,16:18,20,22,26:28,35)]

### Number of factors
# show the maximum number of factors
fa.parallel(total_factor, fm='wls', fa='fa')
# Parallel analysis suggests that the number of factors = 6

#Factor Analysis
fit.fa <- fa(total_factor, nfactors=6, rotate="oblimin", fm="wls")
print(fit.fa) #RMSR:0.01, TLI:0.932, RMSEA:0.085
print(fit.fa$loadings, cutoff=0.4, sort=T) #요인적재량(변수와 요인간의 관계 정도)>0.4 :유의(보수적)
fa.diagram(fit.fa)


#extract factor
factor <- as.data.frame(fit.fa$scores)
total_factor <- cbind(total_full[,1:9], factor)

#make total_factor excluding clients informaiton
write.csv(total_factor, "./total_factor.csv", row.names=FALSE)
