getwd()
.libPaths('/home/ubuntu/R/x86_64-pc-linux-gnu-library/3.2')

setwd("/home/Shb1101/big")

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
