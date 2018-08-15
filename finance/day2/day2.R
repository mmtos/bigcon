getwd()
.libPaths('/home/ubuntu/R/x86_64-pc-linux-gnu-library/3.2')

setwd("/home/Shb1101/big")
data <- read.csv("./CSVFile_2018-08-07T17_01_42.csv")


######1. 고객기본정보 NULL값 변환######
#(data 테이블)
data2 <- data
data2[is.na(data2[,'DOUBLE_IN'])==TRUE, 'DOUBLE_IN'] <- 3
data2[(is.na(data2[,'NUMCHILD'])==TRUE) & (data2[,'DOUBLE_IN']==3), 'NUMCHILD'] <- 4
data2[(is.na(data2[,'NUMCHILD'])==TRUE) & (data2[,'DOUBLE_IN']!=3), 'NUMCHILD'] <- 0

summary(data)

write.csv(data2, file="./data2.csv", row.names=TRUE)

#(제출용 테이블) 행의 개수는 유지, factor변수(MARRY_Y)의 level을 data2와 동기화 시킴. 
#copy는 분석을 위해 개인정보들을 약간 수정한 테이블이므로
#분석이 끝나고 다 채워진 20여개 금융정보들은 기존에 있는 제출용 데이터와 MERGE시켜야 함.
copy <- read.csv("./1_DataSet.csv")
copy[is.na(copy[,'DOUBLE_IN'])==TRUE, 'DOUBLE_IN'] <- 3
copy[is.na(copy[,'NUMCHILD'])==TRUE, 'NUMCHILD'] <- 4
copy[(is.na(copy[,'MARRY_Y'])==TRUE) & (copy[,'DOUBLE_IN']==3), 'MARRY_Y'] <- 1
copy[(is.na(copy[,'MARRY_Y'])==TRUE) & (copy[,'DOUBLE_IN']!=3), 'MARRY_Y'] <- 2

write.csv(copy, "./copy.csv", row.names = FALSE)

######2. Log regression######
data2 <- read.csv("./data2.csv")
copy <- read.csv("./copy.csv")

###2.1 TOT_ASSET###
m <- lm(log10(TOT_ASSET) ~ factor(SEX_GBN) + factor(AGE_GBN) + factor(JOB_GBN) + factor(ADD_GBN) + factor(INCOME_GBN)
        + factor(MARRY_Y) + factor(DOUBLE_IN) + factor(NUMCHILD), data=data2)
summary(m)

topredict <- copy[,c(2:9)]

temp <- predict(m,topredict)
summary(temp)
predicted_TOT_ASSET <- 10^temp
cbindtemp<-cbind(topredict,predicted_TOT_ASSET)

temp2 <- predict(m,data2)
temp2<- temp2^10
cbindtemp2<-cbind(data2$TOT_ASSET,temp2)

###box plot###
plot(sort(data$TOT_ASSET))
plot(sort(log(data$TOT_ASSET)))
boxplot(log(data$TOT_ASSET))
boxplot(data$ASS_FIN)