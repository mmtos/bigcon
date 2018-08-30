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
trans<-data.frame()
temp<-total_sparse
for(i in 1:34){
 tobind<-data.frame('U'=temp[,'idx'],'I'=i,'R'=temp[,i])
 trans<<-rbind(trans,tobind)
}
summary(trans)
traindata<-trans[is.na(trans[,'R'])==FALSE,]
traindata<-as.data.table(traindata)
write.table(traindata, file="train.txt", sep=" ", row.names = FALSE, col.names = FALSE)

#test(only finance item)
users<-total_sparse$idx
items<-9:34
testdata<-merge(users,items)
write.table(testdata, file="test.txt", sep=" ", row.names = FALSE, col.names = FALSE)

###2.Apply Matrix Factorization
train<-data_file('train.txt')
test<-data_file('test.txt')
r = Reco()
system.time(opts <- r$tune(train,opts=list(lrate=c(0.1,0.2), costp_l1=0, costq_l2=0, nthread=4, niter=10,nmf=TRUE)))
system.time(r$train(train, opts= c(opts$min,nthread=4,nmf=TRUE)))

pred_v <- r$predict(test, out_memory())
pred_df <- cbind(testdata,pred_v)
summary(pred_df)

#make total_full
total<-read.csv('./total.csv')total_full
colnames(total)
colnames(pred_df)
customerinfo<-total[1:9]
financeinfo<-dcast(pred_df,x~y,fill=0)[-1]
total_full<-cbind(customerinfo,financeinfo)

summary(total_full)
write.csv(total_full,file="total_full.csv",row.names = FALSE)
