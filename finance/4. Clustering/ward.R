############ 요인분석 ############
x = data2[2:9]
m = mean(x)
S = cov(x)
R = cor(x)
fact1 = factanal(x, factors=4, rotation="none") #no rotation
fact2 = factanal(x, factors=4, scores="regression")
fact3 = factanal(x, factors=4, rotation="promax")

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


############ 군집분석 ############
# Kmeans : 각 군집을 centroid(변수들의 평균 벡터)로 나타냄 > 이상치에 민감한 단점
# PAM : 여러 거리 측정법 사용 가능 > 퍼포먼스가 떨어짐
library(caret)

# k-means 군집분석은 관측치 간의 거리를 이용하기 때문에 변수의 단위가 매우 중요
training.data <- scale(data2[,-1]) #데이터 표준화

training.data <- as.data.frame(training.data)
summary(training.data)
training.data[is.na(training.data)==TRUE] <- 0
kmeans <- kmeans(training.data, centers = 10, iter.max = 10000)

table(kmeans$cluster) #군집 크기 확인(객체 개수 확인)
kmeans$center #중심점 확인

plot(kmeans, training.data)
xcluster <- kmeans$cluster
kmeans_plot <- cbind(cluster, )

### 군집 중심 개수 결정
library(NbClust)
nc <- NbClust(x, min.nc=2, max=15, method="kmeans")




### 군집분석 Ward 방법 ###
attach(data2)
x <- data2[,2:9]
dx<-round(dist(x),digits = 2)
dx
hc = hclust(dist(x)^2, method='ward.D')
hc
summary(hc)
plot(hc,labels=idx, hang = -1)


hc.result = cutree(hc,k=10000)
plot(x,pch=hc.result)
hc.result
length(unique(hc.result))

### 군집 중심 개수 결정 - mclust ###
memory.limit(size=128000)
gc()
library(mclust)
data_mc = Mclust(x)
data_mc
data_mc$classification

### NbClust - 용량 부족 ###
library(NbClust)
y <- x[1:7000,]
nc <- NbClust(x, min.nc=2, max=5, method="kmeans")
nc=NbClust(x,distance="euclidean",min.nc=2,max.nc=15, method="average")
res<-NbClust(y, distance = "euclidean", min.nc=2, max.nc=5, 
             method = "ward.D", index = "all")

### K-means ###

data_k <- kmeans(x, centers=198)
length(unique(data_k$cluster))
ccent = function(y, cl){
  f=function(i)
}
ccent(x, data_k$cluster)

### 집단내 제곱합 그래프 그리는 함수 - 급격한 경사가 있는 부분에서 군집 개수 결정 ###
wssplot <- function(data, nc=100, seed=1234){
  wss <- (nrow(data)-1)*sum(apply(data,2,var))
  for (i in 2:nc){
    set.seed(seed)
    wss[i] <- sum(kmeans(data, centers=i)$withinss)}
  plot(1:nc, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")} 
df<-scale(x)
wssplot(df)





