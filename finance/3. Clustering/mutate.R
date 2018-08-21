###### 파생변수 생성 ######

library(dplyr)
data <- read.csv("./missForest_imp_data.csv")

###### 1. Chararter ######

### 1) 평균소비성향(Average Propensity to Consume, APC) : 소비(TOT_SOBI) / 소득(TOT_SOBI + M_TOT_SAVING)
### 2) 위험감수(Risk taking)성향 
### 2-1) 월 투자금(펀드/주식)(M_FUND_STOCK) / 월저축액(M_TOT_SAVING)
### 2-2) 금융상품잔액(TOT_FUND + TOT_ELS_ETE) / 금융자산(ASS_FIN)

data2 <- data %>% mutate(APC = TOT_SOBI/(TOT_SOBI+M_TOT_SAVING))

data2 <- data2 %>% mutate(M_RT_INVEST = M_FUND_STOCK/M_TOT_SAVING)
nrow(sqldf("select M_RT_INVEST from data2 where M_RT_INVEST != 0"))/nrow(data2) #11.7% 값 존재
#오직 2014개 데이터만 M_FUND_STOCK 값 존재. 때문에 대부분의 M_RT_INVEST 값이 0

data2 <- data2 %>% mutate(TOT_RT_INVEST = (TOT_FUND + TOT_ELS_ETE)/ASS_FIN)


###### 2. Capacity ######

### 1) DTI : 총 대출액(TOT_DEBT) / 총 소득(TOT_SOBI + M_TOT_SAVING)

data2 <- data2 %>% mutate(DTI = TOT_DEBT/(TOT_SOBI + M_TOT_SAVING))
nrow(sqldf("select DTI from data2 where DTI != 0"))/nrow(data2) #58% 값 존재


###### 3. Capital ######

### 1) 자기 자본 비율 : 총 자산(TOT_ASSET) - 부채(TOT_DEBT) / 총 자산(TOT_ASSET)

data2 <- data2 %>% mutate(BIS = (TOT_ASSET-TOT_DEBT)/TOT_ASSET)
nrow(sqldf("select BIS from data2 where BIS != 0"))/nrow(data2) #99.9% 값 존재
#참고 : 부채가 없는 데이터 7101개

write.csv(data2, "./mutate_data.csv", row.names=FALSE)
