getwd()
.libPaths('/home/ubuntu/R/x86_64-pc-linux-gnu-library/3.2')

data2 <- read.csv("./data2.csv")
copy <- read.csv("./copy.csv")
answer2 <- copy[,1:9]

###### 요인분석 ######
x = data2[2:9]
m = mean(x)
S = cov(x)
R = cor(x)
fact1 = factanal(x, factors=4, rotation="none") #no rotation
fact2 = factanal(x, factors=4, scores="regression")
fact3 = factanal(x, factors=4, rotation="promax")

fact1
fact2
fact3

# scree plot : 요인 개수 결정
library(graphics)
prin = princomp(x)
screeplot(prin, npcs=6, type="lines", main="scree plot")

# 요인 패턴 그래프 : 요인 적재값 확인
namevar = names(fact2$loadings) = c("x1","x2","x3","x4","x5","x6","x7","x8")
plot(fact2$loadings[,1], fact2$loadings[,2], pch=16, xlab="factor1", ylab="factor2", main="factor pattern")
text(x=fact2$loadings[,1], y=fact2$loadings[,2], labels=namevar, adj=0)
abline(v=0, h=0)

#요인 스코어 그래프
plot(fact2$scores[,1], fact2$scores[,2], pch="*", xlab="factor1", ylab="factor2", main="factor scores")

