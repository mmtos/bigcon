## 금융정보있는 테이블에 군집번호 cbind
total_cluster<-read.csv('./total_cluster.csv')
total_full<-read.csv('./total_full_xgb1.csv')
str(total_full)
str(total_cluster)
total_cluster_cbind<-cbind(total_full,total_cluster$group_k.cluster)
str(total_cluster_cbind)

## 금융정보, 총저축금액, 총소비금액만 뽑아서 군집번호 열이름 'cluster'로 수정
total_cluster_cbind<-total_cluster_cbind[,c(11,14,34,36)]
colnames(total_cluster_cbind)<-c("ASS_FIN","M_TOT_SAVING","TOT_SOBI","CLUSTER")

##군집별로 금융사잔, 총저축금액, 총소비금액의 평균 구하기
#total_cluster_cbind1<-total_cluster_cbind[total_cluster_cbind$CLUSTER==1,]
#quantile(total_cluster_cbind1$ASS_FIN, seq(0,1,0.01))
#(max(total_cluster_cbind1$ASS_FIN)-min(total_cluster_cbind1$ASS_FIN))/100

#x <- data.frame("cluster1" = c(806.98,4252.07), "cluster2" = c(10,400), "cluster3" = c(2000,4000))
#x2
#x2<-`row.names<-`(x,c('min','max'))
#x2.t<-t(x2)
#quan1<-quantile(x2$cluster1,seq(0,1,0.01))
#quan2<-quantile(x2$cluster2,seq(0,1,0.01))
#quan3<-quantile(x2$cluster3,seq(0,1,0.01))
#quan<-rbind(quan1,quan2,quan3)
#result<- cbind(x2.t,quan)
#cluster1<-c()
#max(total_cluster_cbind1$ASS_FIN)

write.csv(total_cluster_cbind, './total_cluster_cbind.csv')

## 군집별로 그룹화하기 위한 for문
## 먼저 cluster가 1인 그룹으로 qor_all이라는 그룹을 만들어줌 
## for문을 돌려서 나온 결과를 계속 겹쳐서 rbind하기 위해 기준 테이블 만들어 줌
total_cluster_cbind_1<-total_cluster_cbind[total_cluster_cbind$CLUSTER==1,]
# 각 열의 백분위 구하기
ASS_FIN<-quantile(total_cluster_cbind_1[,1],seq(0,1,0.01))
M_TOT_SAVING<-quantile(total_cluster_cbind_n[,2],seq(0,1,0.01))
TOT_SOBI<-quantile(total_cluster_cbind_n[,3],seq(0,1,0.01))
# rbind하여 qor_all이라는 변수에 저장
qor_all<-rbind(ASS_FIN,M_TOT_SAVING,TOT_SOBI)

## 2번째 군집부터 for문 돌리기
for (i in 2:1015){
  total_cluster_cbind_n<-total_cluster_cbind[total_cluster_cbind$CLUSTER==i,]
  ASS_FIN<-quantile(total_cluster_cbind_n[,1],seq(0,1,0.01))
  M_TOT_SAVING<-quantile(total_cluster_cbind_n[,2],seq(0,1,0.01))
  TOT_SOBI<-quantile(total_cluster_cbind_n[,3],seq(0,1,0.01))
  qor<-rbind(ASS_FIN,M_TOT_SAVING,TOT_SOBI)
  qor_all<-rbind(qor_all,qor)
}
str(qor_all)
head(qor_all)
qor_all<-as.data.frame(qor_all)

## 행이름 수정
rownames(qor_all)<-seq(1:3045)
PEER_GROUP_No<-rep(1:1015,each=3)
COLUMN_NAME<-rep(c('금융자산','월저축금액','월소비금액'),1015)
qor_all<-cbind(PEER_GROUP_No,COLUMN_NAME,qor_all)
head(qor_all)

write.csv(qor_all,'./total_pecentile.csv',row.names = FALSE)

###########################################
x <- data.frame("clusterno"=c(1,1,1,2,2,3,3,3),"data1" = c(30,524,2975,20000,45,8,88,888), "data2" = c(10,346,23,400,897,9,99,999), "data3" = c(2000,2424,3523,2222,4000,7,77,777))
x$clusterno<-as.factor(x$clusterno)
class(x$clusterno)
f <- function(vec){ quantile(vec,seq(0,1,0.01))}
result<-tapply(x$data1, x$clusterno, f)
temp<-as.data.frame(result[1])
for (i in 2:length(result)){
  temp<-cbind(temp,result[[i]])
}
rm(i)
colnames(temp)<-1:length(result)
data1_100_quan<-as.data.frame(t(temp))
clusterno<-rownames(data1_100_quan)
finance_feature <- "data1"
data1_100_quan<-cbind(clusterno,finance_feature,data1_100_quan)

##for data2
result<-tapply(x$data2, x$clusterno, f)
temp<-as.data.frame(result[1])
for (i in 2:length(result)){
  temp<-cbind(temp,result[[i]])
}
rm(i)
colnames(temp)<-1:length(result)
data2_100_quan<-as.data.frame(t(temp))
clusterno<-rownames(data2_100_quan)
finance_feature <- "data2"
data2_100_quan<-cbind(clusterno,finance_feature,data2_100_quan)

#for data3
result<-tapply(x$data3, x$clusterno, f)
temp<-as.data.frame(result[1])
for (i in 2:length(result)){
  temp<-cbind(temp,result[[i]])
}
rm(i)
colnames(temp)<-1:length(result)
data3_100_quan<-as.data.frame(t(temp))
clusterno<-rownames(data3_100_quan)
finance_feature <- "data3"
data3_100_quan<-cbind(clusterno,finance_feature,data3_100_quan)
result<- rbind(data1_100_quan,data2_100_quan,data3_100_quan)

