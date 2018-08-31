rm(list=ls())

###패키지 설치
#install.packages("recosystem") matrix factorization 적용 시 필요한 라이브러리
library(recosystem)
#install.packages("data.table") data들의 합산을 처리하기 위한 라이브러리(ex:merge, aggregate)
library(data.table)

# make train,testset by transforming the datas
#train
total_sparse<-read.csv('./total_sparse.csv')
total_sparse['idx']<-1:nrow(total_sparse)

summary(total_sparse['INCOME_GBN'])
splitbyincome <- function(data,income){
  tot<-data[data$INCOME_GBN==income,]
  return (tot)
}
transtodense<-function(tots){
    trans<-data.frame()
    for(i in 1:34){
      tobind<-data.frame('U'=tots[,'idx'],'I'=i,'R'=tots[,i])
      trans<-rbind(trans,tobind)
    }
    trans<-trans[is.na(trans[,'R'])==FALSE,]
  return (trans)
}
makedatasource<-function(trainset){
  return (data_memory(trainset$U,trainset$I,rating = trainset$R,index1=TRUE))
}
maketrainlist<-function(data){
  trans1<- transtodense(splitbyincome(data,1))
  train1<-makedatasource(trans1)
  
  trans2<- transtodense(splitbyincome(data,2))
  train2<-makedatasource(trans2)
  
  trans3<- transtodense(splitbyincome(data,3))
  train3<-makedatasource(trans3)
  
  trans4<- transtodense(splitbyincome(data,4))
  train4<-makedatasource(trans4)
  
  trans5<- transtodense(splitbyincome(data,5))
  train5<-makedatasource(trans5)
  
  trans6<- transtodense(splitbyincome(data,6))
  train6<-makedatasource(trans6)
  
  trans7<- transtodense(splitbyincome(data,7))
  train7<-makedatasource(trans7)
  return (list('train1'=train1,'train2'=train2,'train3'=train3,'train4'=train4,'train5'=train5,'train6'=train6,'train7'=train7))
}
trainlist <- maketrainlist(total_sparse)

#test(only finance item)
maketestset<-function(data,income){
  users<- splitbyincome(data,income)$idx
  items<-9:34
  testdata<-merge(users,items)
  colnames(testdata)<-c('U','I')
  return (data_memory(testdata$U,testdata$I,index1=TRUE)) 
}
maketestlist<-function(data){
  test1<-maketestset(data,1)
  test2<-maketestset(data,2)
  test3<-maketestset(data,3)
  test4<-maketestset(data,4)
  test5<-maketestset(data,5)
  test6<-maketestset(data,6)
  test7<-maketestset(data,7)
  return (list('test1'=test1,'test2'=test2,'test3'=test3,'test4'=test4,'test5'=test5,'test6'=test6,'test7'=test7))
}
testlist<- maketestlist(total_sparse)

maketestdataset<-function(data,income){
  users<- splitbyincome(data,income)$idx
  items<-9:34
  testdata<-merge(users,items)
  colnames(testdata)<-c('U','I')
  return (testdata) 
}
maketestdatalist<-function(data){
  test1<-maketestdataset(data,1)
  test2<-maketestdataset(data,2)
  test3<-maketestdataset(data,3)
  test4<-maketestdataset(data,4)
  test5<-maketestdataset(data,5)
  test6<-maketestdataset(data,6)
  test7<-maketestdataset(data,7)
  return (list('testdata1'=test1,'testdata2'=test2,'testdata3'=test3,'testdata4'=test4,'testdata5'=test5,'testdata6'=test6,'testdata7'=test7))
}
testdatalist<-maketestdatalist(total_sparse)

###2.Apply Matrix Factorization

set.seed(123)
make_pred_df_sub<-function(train,test,testdata){
r = Reco()
opts <- r$tune(train,opts=list(lrate=c(0.1,0.2), costp_l1=0, costq_l2=0, nthread=4, niter=10,nmf=TRUE))
r$train(train, opts= c(opts$min,nthread=4,nmf=TRUE))
pred_v <- r$predict(test, out_memory())
pred_df <- cbind(testdata,pred_v)
return (pred_df)
}
make_pred_df<-function(){
pred1<-make_pred_df_sub(trainlist$train1,testlist$test1,testdatalist$testdata1)
pred2<-make_pred_df_sub(trainlist$train2,testlist$test2,testdatalist$testdata2)
pred3<-make_pred_df_sub(trainlist$train3,testlist$test3,testdatalist$testdata3)
pred4<-make_pred_df_sub(trainlist$train4,testlist$test4,testdatalist$testdata4)
pred5<-make_pred_df_sub(trainlist$train5,testlist$test5,testdatalist$testdata5)
pred6<-make_pred_df_sub(trainlist$train6,testlist$test6,testdatalist$testdata6)
pred7<-make_pred_df_sub(trainlist$train7,testlist$test7,testdatalist$testdata7)
return (rbind(pred1,pred2,pred3,pred4,pred5,pred6,pred7))

}
pred_df<-make_pred_df()

#make total_full
total<-read.csv('./total.csv')
customerinfo<-total[1:9]
financeinfo<-dcast(pred_df,U~I,fill=0)[-1]
total_full<-cbind(customerinfo,financeinfo)

#change column names
colnames(total_full) <- colnames(total)
colnames(total_full)

summary(total_full)
write.csv(total_full,file="total_full.csv",row.names = FALSE)
