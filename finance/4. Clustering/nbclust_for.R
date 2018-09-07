rm(list=ls())

total_factor <- read.csv('./total_factor.csv')
str(total_factor)

total_factor$MARRY_Y[is.na(total_factor$MARRY_Y)==TRUE]<-0

## grouping sex=1, age=2:6, job=2, marry=1
## age가 2부터 6까지인 group들을 group1~group5까지의 이름을 가진 csv로 저장
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==2 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i-1,'.csv'),row.names = FALSE)
}
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==3 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+4,'.csv'),row.names = FALSE)
}
## nbclust 
## 저장한 csv파일을 하나씩 가져와서 
## 정규화 한 후에 nbclust~~
## pb$tick()은 얼만큼 진행되었는지 알려주는 표시
## 전부 group화 한후 nbclust 한번에 돌리는 것도 좋을듯
pb<-progress_bar$new(total=5)
for (i in 1:5){
  pb$tick()
  group<-read.csv(paste0('./group',i,'.csv'))
  total_scale<-scale(group[,10:13])
  total_scale<-as.data.frame(total_scale)
  assign(paste0('nc',i),NbClust(total_scale, min.nc=3, max.nc=10, method="kmeans"))
}
