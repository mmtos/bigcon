rm(list=ls())

total_factor <- read.csv('./total_factor.csv')
str(total_factor)

total_factor$MARRY_Y[is.na(total_factor$MARRY_Y)==TRUE]<-0
unique(total_factor$JOB_GBN)

######효영 nbclust 그룹화코드(MARRY_Y==0)#####

## HYOYOUNG: MARRY_Y==0, group1-90
##group1~5
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==2 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i-1,'.csv'),row.names = FALSE)
}
## group6~10
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==3 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+4,'.csv'),row.names = FALSE)
}
## group11~15
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==4 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+9,'.csv'),row.names = FALSE)
}
## group106~110
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==6 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+14,'.csv'),row.names = FALSE)
}
## group111~115
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==7 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+19,'.csv'),row.names = FALSE)
}
## group116~120
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==8 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+24,'.csv'),row.names = FALSE)
}
## group121~125
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==9 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+29,'.csv'),row.names = FALSE)
}
## group126~130
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==10 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+34,'.csv'),row.names = FALSE)
}
## group131~135
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==11 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+39,'.csv'),row.names = FALSE)
}
## group136~140
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==2 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+44,'.csv'),row.names = FALSE)
}
## group141~145
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==3 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+49,'.csv'),row.names = FALSE)
}
## group146~150
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==4 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+54,'.csv'),row.names = FALSE)
}
## group151~155
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==6 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+59,'.csv'),row.names = FALSE)
}
## group156~160
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==7 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+64,'.csv'),row.names = FALSE)
}
## group161~165
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==8 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+69,'.csv'),row.names = FALSE)
}
## group166~170
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==9 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+74,'.csv'),row.names = FALSE)
}
## group171~175
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==10 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+79,'.csv'),row.names = FALSE)
}
## group176~180
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==11 & total_factor$MARRY_Y==0,] 
  write.csv(group, paste0('./group',i+84,'.csv'),row.names = FALSE)
}
## grouping sex=1, age=2:6, job=2, marry=1
## age가 2부터 6까지인 group들을 group1~group5까지의 이름을 가진 csv로 저장
## group91~95
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==2 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+89,'.csv'),row.names = FALSE)
}
## group96~100
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==3 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+94,'.csv'),row.names = FALSE)
}
## group101~105
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==4 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+99,'.csv'),row.names = FALSE)
}
## group106~110
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==6 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+104,'.csv'),row.names = FALSE)
}
## group111~115
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==7 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+109,'.csv'),row.names = FALSE)
}
## group116~120
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==8 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+114,'.csv'),row.names = FALSE)
}
## group121~125
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==9 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+119,'.csv'),row.names = FALSE)
}
## group126~130
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==10 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+124,'.csv'),row.names = FALSE)
}
## group131~135
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==11 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+129,'.csv'),row.names = FALSE)
}
## group136~140
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==2 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+134,'.csv'),row.names = FALSE)
}
## group141~145
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==3 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+139,'.csv'),row.names = FALSE)
}
## group146~150
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==4 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+144,'.csv'),row.names = FALSE)
}
## group151~155
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==6 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+149,'.csv'),row.names = FALSE)
}
## group156~160
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==7 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+154,'.csv'),row.names = FALSE)
}
## group161~165
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==8 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+159,'.csv'),row.names = FALSE)
}
## group166~170
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==9 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+164,'.csv'),row.names = FALSE)
}
## group171~175
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==10 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+169,'.csv'),row.names = FALSE)
}
## group176~180
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==11 & total_factor$MARRY_Y==1,] 
  write.csv(group, paste0('./group',i+174,'.csv'),row.names = FALSE)
}

## group181~185
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==2 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+179,'.csv'),row.names = FALSE)
}
## group186~190
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==3 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+184,'.csv'),row.names = FALSE)
}
## group191~195
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==4 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+189,'.csv'),row.names = FALSE)
}
## group196~200
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==6 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+194,'.csv'),row.names = FALSE)
}
## group201~205
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==7 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+199,'.csv'),row.names = FALSE)
}
## group206~210
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==8 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+204,'.csv'),row.names = FALSE)
}
## group211~215
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==9 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+209,'.csv'),row.names = FALSE)
}
## group216~220
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==10 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+214,'.csv'),row.names = FALSE)
}
## group221~225
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==1 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==11 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+219,'.csv'),row.names = FALSE)
}
## group226~230
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==2 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+224,'.csv'),row.names = FALSE)
}
## group231~235
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==3 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+229,'.csv'),row.names = FALSE)
}
## group236~240
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==4 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+234,'.csv'),row.names = FALSE)
}
## group241~245
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==6 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+239,'.csv'),row.names = FALSE)
}
## group246~250
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==7 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+244,'.csv'),row.names = FALSE)
}
## group251~255
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==8 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+249,'.csv'),row.names = FALSE)
}
## group256~260
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==9 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+254,'.csv'),row.names = FALSE)
}
## group261~265
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==10 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+259,'.csv'),row.names = FALSE)
}
## group266~270
for (i in 2:6){
  group <- total_factor[total_factor$SEX_GBN==2 & total_factor$AGE_GBN==i & total_factor$JOB_GBN==11 & total_factor$MARRY_Y==2,] 
  write.csv(group, paste0('./group',i+264,'.csv'),row.names = FALSE)
}

## nbclust 
## 저장한 csv파일을 하나씩 가져와서 
## 정규화 한 후에 nbclust~~
## pb$tick()은 얼만큼 진행되었는지 알려주는 표시
## 전부 group화 한후 nbclust 한번에 돌리는 것도 좋을듯
pb<-progress_bar$new(total=5)
for (i in 251:270){
  group<-read.csv(paste0('./group',i,'.csv'))
  total_scale<-scale(group[,10:13])
  total_scale<-as.data.frame(total_scale)
  assign(paste0('nc',i),NbClust(total_scale, min.nc=3, max.nc=10, method="kmeans"))
}

## kmeans
nbc <- c(4,4,3,4,4,4,4,4,4,4,
         4,3,4,4,9,4,4,4,4,3,
         4,4,3,4,3,3,4,3,3,3,
         3,4,8,4,3,3,3,3,4,4,
         3,3,3,3,3,4,3,4,4,4,
         4,3,3,4,3,4,4,4,4,3,
         4,4,3,4,3,4,4,3,3,3,
         4,4,4,6,7,5,4,3,3,5,
         3,4,4,4,5,3,4,4,4,3,
         4,3,4,3,3,4,3,3,9,3,
         4,4,3,4,3,4,4,3,4,3,
         3,4,4,5,6,3,4,7,4,3,
         3,4,3,4,4,3,4,3,4,3,
         3,3,7,4,3,4,3,4,4,3,
         4,3,3,4,4,4,4,4,4,3,
         3,4,3,4,3,3,4,4,4,3,
         3,3,3,4,3,4,4,3,4,3,
         3,3,3,4,4,4,3,3,4,4,
         4,4,4,3,4,4,4,3,4,4,
         4,4,4,4,4,4,4,4,4,4,
         4,4,3,3,7,3,4,3,3,3,
         4,3,3,3,4,3,3,3,4,4,
         3,3,3,3,3,4,3,4,3,4,
         4,4,4,4,4,4,4,4,4,4,
         4,4,4,4,4,4,4,3,3,4,
         4,4,3,6,5,4,4,3,4,5,
         3,4,4,4,5,3,4,4,4,3)

sum(nbc[1:3])
for ( i in 1:270){
  group<-read.csv(paste0('./group',i,'.csv'))
  total_scale<-scale(group)
  total_scale<-as.data.frame(total_scale)

  group_head <- group[,1:9]
  group <- group[,10:13]
  
  ## 군집분석을 위한 정규화
  total_scale <- scale(group)
  total_scale <- as.data.frame(total_scale)
  ## kmeans 
  group_k <- kmeans(group,nbc[i])
  group <- cbind(group_head,group,group_k$cluster)
  
  if (i >= 2){
    if(nbc[i]==3){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
    }else if(nbc[i]==4){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
      group$`group_k$cluster`[group$`group_k$cluster`==4]<-sum(nbc[1:(i-1)])+4
    }else if(nbc[i]==5){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
      group$`group_k$cluster`[group$`group_k$cluster`==4]<-sum(nbc[1:(i-1)])+4
      group$`group_k$cluster`[group$`group_k$cluster`==5]<-sum(nbc[1:(i-1)])+5
    }else if(nbc[i]==6){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
      group$`group_k$cluster`[group$`group_k$cluster`==4]<-sum(nbc[1:(i-1)])+4
      group$`group_k$cluster`[group$`group_k$cluster`==5]<-sum(nbc[1:(i-1)])+5
      group$`group_k$cluster`[group$`group_k$cluster`==6]<-sum(nbc[1:(i-1)])+6
    }else if(nbc[i]==7){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
      group$`group_k$cluster`[group$`group_k$cluster`==4]<-sum(nbc[1:(i-1)])+4
      group$`group_k$cluster`[group$`group_k$cluster`==5]<-sum(nbc[1:(i-1)])+5
      group$`group_k$cluster`[group$`group_k$cluster`==6]<-sum(nbc[1:(i-1)])+6
      group$`group_k$cluster`[group$`group_k$cluster`==7]<-sum(nbc[1:(i-1)])+7
    }else if(nbc[i]==8){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
      group$`group_k$cluster`[group$`group_k$cluster`==4]<-sum(nbc[1:(i-1)])+4
      group$`group_k$cluster`[group$`group_k$cluster`==5]<-sum(nbc[1:(i-1)])+5
      group$`group_k$cluster`[group$`group_k$cluster`==6]<-sum(nbc[1:(i-1)])+6
      group$`group_k$cluster`[group$`group_k$cluster`==7]<-sum(nbc[1:(i-1)])+7
      group$`group_k$cluster`[group$`group_k$cluster`==8]<-sum(nbc[1:(i-1)])+8
    }else if(nbc[i]==9){
      group$`group_k$cluster`[group$`group_k$cluster`==1]<-sum(nbc[1:(i-1)])+1
      group$`group_k$cluster`[group$`group_k$cluster`==2]<-sum(nbc[1:(i-1)])+2
      group$`group_k$cluster`[group$`group_k$cluster`==3]<-sum(nbc[1:(i-1)])+3
      group$`group_k$cluster`[group$`group_k$cluster`==4]<-sum(nbc[1:(i-1)])+4
      group$`group_k$cluster`[group$`group_k$cluster`==5]<-sum(nbc[1:(i-1)])+5
      group$`group_k$cluster`[group$`group_k$cluster`==6]<-sum(nbc[1:(i-1)])+6
      group$`group_k$cluster`[group$`group_k$cluster`==7]<-sum(nbc[1:(i-1)])+7
      group$`group_k$cluster`[group$`group_k$cluster`==8]<-sum(nbc[1:(i-1)])+8
      group$`group_k$cluster`[group$`group_k$cluster`==9]<-sum(nbc[1:(i-1)])+9
    }
  }
  write.csv(group,paste0('./group',i,'_k.csv'),row.names = FALSE)
}
#group1<-read.csv('./group1.csv')
#head(group1)
#head(group6)
#km <- read.csv('./group2_k.csv')
#head(km)
#table(km$group_k.cluster)

groupp1<-read.csv('./group1_k.csv')
groupp2<-read.csv('./group2_k.csv')
groupp85<-read.csv('./group85_k.csv')


group<-rbind(groupp1,groupp2)
str(group)
for (i in 3:270){
  aa<-read.csv(paste0('./group',i,'_k.csv'))
  group<-rbind(group,aa)
}
table(group$group_k.cluster)
unique(order(group$group_k.cluster))
length(unique(group$group_k.cluster))
group_kmeans<-group[order(group$PEER_NO),]
head(group_kmeans)
write.csv(group_kmeans,'./total_cluster.csv',row.names = FALSE)

hohoho<- read.csv('./group26.csv')
hohoho1<- read.csv('./group146.csv')
hohoho <- as.data.frame(hohoho)
total_cluster <- read.csv('./total_cluster.csv')
colnames(total_cluster)
peer_group <- total_cluster[,c(1,14)]
write.csv(peer_group,'./peer_group.csv',row.names = FALSE)

group_k
library(ggplot2)
plot(groupp1$WLS1,groupp1$WLS2,col=groupp1$group_k.cluster)
plot(groupp85$WLS1,groupp85$WLS2,col=groupp85$group_k.cluster)
plot(groupp86$WLS2,groupp86$WLS4,col=groupp86$group_k.cluster)

plot(groupp101$WLS1,groupp101$WLS3,col=groupp101$group_k.cluster)

plot(groupp86$WLS1,groupp85$WLS2,col=groupp86$group_k.cluster)
plot(groupp86$WLS1,groupp85$WLS2,col=groupp86$group_k.cluster)
plot(groupp86$WLS1,groupp85$WLS2,col=groupp86$group_k.cluster)
plot(groupp86$WLS1,groupp85$WLS2,col=groupp86$group_k.cluster)
plot(groupp86$WLS1,groupp85$WLS2,col=groupp86$group_k.cluster)

plot(group_alll$WLS1,group_alll$WLS2,col=group_alll$group_k.cluster)

a<-groupp1[,10:13]


####################20180910######################
all_scale<-scale(total_factor[,10:13])
all_scale<-as.data.frame(all_scale)
group_all<-kmeans(all_scale,1015)
group_all$cluster
table(group_all$cluster)
group_all<-cbind(total_factor,group_all$cluster)
head(group_all)
write.csv(group_all,'./group_all.csv',row.names = FALSE)
group_alll<-read.csv('./group_all.csv')
group_all_age2<-group_all[group_all$AGE_GBN==2,]




str(total_full)
total_full<-scale(total_full[,10:35])
total_full<-as.data.frame(total_full)
total_full<-kmeans(total_full,1015)
total_full<-cbind(total_full$cluster,total_full_123)
write.csv(total_full,'./total_full_kmeans.csv',row.names = FALSE)
summary(total_full)
total_full$MARRY_Y[is.na(total_full$MARRY_Y)==TRUE]<-0
a<-total_full[total_full$AGE_GBN==4 & total_full$MARRY_Y==2,]
str(a)
total_full<-read.csv()
