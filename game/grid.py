#%%
from multiprocessing import Process
import pandas as pd
import sys
import os
path = 'C:/Users/jsh/Desktop/game'
sys.path.append(path)
from sklearn.metrics import accuracy_score
#%%
train_data = pd.read_csv(path+'/total/train0910_pca.csv')
test_data = pd.read_csv(path+'/total/test0910_pca.csv')
#%%
from sklearn.model_selection import StratifiedShuffleSplit

split = StratifiedShuffleSplit(n_splits=1, test_size = 0.2, random_state=123)
for train_index, valid_index in split.split(train_data, train_data["label"]):
    train,valid = train_data.loc[train_index], train_data.loc[valid_index]
    feats = [f for f in train_data.columns if f not in ['acc_id','label']]
    train_x=train[feats]
    train_y=train['label']
    valid_x=valid[feats]
    valid_y=valid['label']
#%%    
test_acc_id=pd.DataFrame(test_data['acc_id'],columns=['acc_id'])
train_acc_id=pd.DataFrame(train_data['acc_id'],columns=['acc_id'])
valid_acc_id=pd.DataFrame(valid['acc_id'],columns=['acc_id'])
valid_acc_id.reset_index(inplace=True)
del valid_acc_id['index']

#%%
pred_valid_kfold=pd.read_csv(path+'/submission/pred_valid_kfold.csv')
pred_test_kfold=pd.read_csv(path+'/submission/pred_test_kfold.csv')

pred_valid_lgb=pd.read_csv(path+'/submission/pred_valid_lgb.csv')
pred_test_lgb=pd.read_csv(path+'/submission/pred_test_lgb.csv')

pred_valid_lgb2=pd.read_csv(path+'/submission/pred_valid_lgb2.csv')
pred_test_lgb2=pd.read_csv(path+'/submission/pred_test_lgb2.csv')

pred_valid_paste_rf=pd.read_csv(path+'/submission/pred_valid_paste_rf.csv')
pred_test_paste_rf=pd.read_csv(path+'/submission/pred_test_paste_rf.csv')

pred_valid_xgb=pd.read_csv(path+'/submission/pred_valid_xgb.csv')
pred_test_xgb=pd.read_csv(path+'/submission/pred_test_xgb.csv')

pred_valid_ada=pd.read_csv(path+'/submission/pred_valid_ada.csv')
pred_test_ada=pd.read_csv(path+'/submission/pred_test_ada.csv')

#%%
def predict_proba_to_predict(pp,test_id):
    pp.columns=['2month','month','retained','week']
    pp=pd.concat([test_id,pp],axis=1)
    pp_melted = pd.melt(pp, id_vars=['acc_id'], var_name='label')
    num_agg={'value':['max']}
    pp_melted_agg = pp_melted.groupby('acc_id').agg(num_agg)
    pp_melted_agg.reset_index(inplace=True)
    pp_melted_agg.columns = ['acc_id','value2']    
    predict=pp_melted.merge(pp_melted_agg,how='left',on='acc_id')
    predict_last=predict.loc[predict['value']==predict['value2'],]
    return predict_last

#%%
def grid(l1,l2,l3,l4,l5,l6):
    result=0.7
    for a in l1:
        for b in l2:
            for c in l3:
                for d in l4:
                    for e in l5:
                        for f in l6:
                            pred_valid_soft = (a*pred_valid_paste_rf
                                               +b*pred_valid_kfold
                                               +c*pred_valid_lgb
                                               +d*pred_valid_xgb
                                               +e*pred_valid_ada
                                               +f*pred_valid_lgb2)/(a+b+c+d+e+f)
                            temp = predict_proba_to_predict(pred_valid_soft,valid_acc_id)
                            temp2 = valid_acc_id.merge(temp,how='left',on='acc_id')
                            result = max(result,accuracy_score(temp2['label'],valid['label']))
                            if result>0.737:
                                print(os.getpid(),':',a,b,c,d,e,f,result)
                                result=0
#%%
i=[0,1,2,3,4,5]
i2=[1,2,3,4,5]
if __name__=='__main__':
    print('start!!!')
    p1=Process(target=grid,args=([5],i2,i,i,i,i))
    p2=Process(target=grid,args=([4],i2,i,i,i,i))
    p3=Process(target=grid,args=([3],i2,i,i,i,i))
    p4=Process(target=grid,args=([2],i2,i,i,i,i))
    p5=Process(target=grid,args=([1],i2,i,i,i,i))
    
    p1.start()
    p2.start()
    p3.start()
    p4.start()
    p5.start()
    
    p1.join()
    p2.join()
    p3.join()
    p4.join()
    p5.join() 