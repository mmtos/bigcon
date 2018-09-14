#%%
#%%
import gc
import numpy as np
import pandas as pd
import sys
import pickle
path = 'C:/Users/jsh/Desktop/game'
sys.path.append(path)
from sklearn.metrics import accuracy_score
#%%
train_data = pd.read_csv(path+'/total/trainset.csv')
test_data = pd.read_csv(path+'/total/testset.csv')
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
labels=['2month','month','retained','week']
clf_lgb2 = pickle.load(open("C:/Users/jsh/Desktop/game/lgb.pickle", "rb"))
pred_valid_lgb2=clf_lgb2.predict_proba(valid_x)
pred_valid_lgb2=pd.DataFrame(pred_valid_lgb2)
pred_valid_lgb2.columns=labels
pred_test_lgb2=clf_lgb2.predict_proba(test_data[feats])
pred_test_lgb2=pd.DataFrame(pred_test_lgb2)
pred_test_lgb2.columns=labels
pred_valid_lgb2.to_csv(path+'/submission/pred_valid_lgb2.csv', index= False)
pred_test_lgb2.to_csv(path+'/submission/pred_test_lgb2.csv', index= False)
#%%
import gc
import numpy as np
import pandas as pd
import sys
import pickle
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
labels=['2month','month','retained','week']
clf_lgb = pickle.load(open("C:/Users/jsh/Desktop/game/lgb_pca6.pickle", "rb"))
pred_valid_lgb=clf_lgb.predict_proba(valid_x)
pred_valid_lgb=pd.DataFrame(pred_valid_lgb)
pred_valid_lgb.columns=labels
pred_test_lgb=clf_lgb.predict_proba(test_data[feats])
pred_test_lgb=pd.DataFrame(pred_test_lgb)
pred_test_lgb.columns=labels
pred_valid_lgb.to_csv(path+'/submission/pred_valid_lgb.csv', index= False)
pred_test_lgb.to_csv(path+'/submission/pred_test_lgb.csv', index= False)

#%%
clf_xgb = pickle.load(open("C:/Users/jsh/Desktop/game/xgb3.pickle", "rb"))
pred_valid_xgb=clf_xgb.predict_proba(valid_x)
pred_valid_xgb=pd.DataFrame(pred_valid_xgb)
pred_valid_xgb.columns=labels
pred_test_xgb=clf_xgb.predict_proba(test_data[feats])
pred_test_xgb=pd.DataFrame(pred_test_xgb)
pred_test_xgb.columns=labels
pred_valid_xgb.to_csv(path+'/submission/pred_valid_xgb.csv', index= False)
pred_test_xgb.to_csv(path+'/submission/pred_test_xgb.csv', index= False)
#%%
clf_ada = pickle.load(open("C:/Users/jsh/Desktop/game/ada.pickle", "rb"))
pred_valid_ada=clf_ada.predict_proba(valid_x)
pred_valid_ada=pd.DataFrame(pred_valid_ada)
pred_valid_ada.columns=labels
pred_test_ada=clf_ada.predict_proba(test_data[feats])
pred_test_ada=pd.DataFrame(pred_test_ada)
pred_test_ada.columns=labels
pred_valid_ada.to_csv(path+'/submission/pred_valid_ada.csv', index= False)
pred_test_ada.to_csv(path+'/submission/pred_test_ada.csv', index= False)
#%%
clf_paste_rf = pickle.load(open("C:/Users/jsh/Desktop/game/rf.pickle", "rb"))
pred_valid_paste_rf=clf_paste_rf.predict_proba(valid_x)
pred_valid_paste_rf=pd.DataFrame(pred_valid_paste_rf)
pred_valid_paste_rf.columns=labels
pred_test_paste_rf=clf_paste_rf.predict_proba(test_data[feats])
pred_test_paste_rf=pd.DataFrame(pred_test_paste_rf)
pred_test_paste_rf.columns=labels
pred_valid_paste_rf.to_csv(path+'/submission/pred_valid_paste_rf.csv', index= False)
pred_test_paste_rf.to_csv(path+'/submission/pred_test_paste_rf.csv', index= False)

#%%
pred_train_kfold = pd.read_csv(path+'/submission/kfoldoofproba.csv')
pred_train_kfold=pd.DataFrame(pred_train_kfold)
pred_train_kfold.columns=labels
pred_train_kfold_with_id=pd.concat([train_acc_id,pred_train_kfold],axis=1)
pred_valid_kfold = pred_train_kfold_with_id.loc[valid_index]
pred_valid_kfold.reset_index(inplace=True)
del pred_valid_kfold['index'],pred_valid_kfold['acc_id']

pred_test_kfold = pd.read_csv(path+'/submission/kfoldproba.csv')
pred_test_kfold=pd.DataFrame(pred_test_kfold)
pred_test_kfold.columns=labels

pred_valid_kfold.to_csv(path+'/submission/pred_valid_kfold.csv', index= False)
pred_test_kfold.to_csv(path+'/submission/pred_test_kfold.csv', index= False)

#%%
pred_valid_kfold=pd.read_csv(path+'/submission/pred_valid_kfold.csv')
pred_test_kfold=pd.read_csv(path+'/submission/pred_test_kfold.csv')

pred_valid_lgb=pd.read_csv(path+'/submission/pred_valid_lgb.csv')
pred_test_lgb=pd.read_csv(path+'/submission/pred_test_lgb.csv')

pred_valid_paste_rf=pd.read_csv(path+'/submission/pred_valid_paste_rf.csv')
pred_test_paste_rf=pd.read_csv(path+'/submission/pred_test_paste_rf.csv')

pred_valid_xgb=pd.read_csv(path+'/submission/pred_valid_xgb.csv')
pred_test_xgb=pd.read_csv(path+'/submission/pred_test_xgb.csv')

pred_valid_ada=pd.read_csv(path+'/submission/pred_valid_ada.csv')
pred_test_ada=pd.read_csv(path+'/submission/pred_test_ada.csv')

pred_valid_lgb2=pd.read_csv(path+'/submission/pred_valid_lgb2.csv')
pred_test_lgb2=pd.read_csv(path+'/submission/pred_test_lgb2.csv')

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
#%% grid.py 실행결과 최적가중치 
pred_valid_soft = (1*pred_valid_paste_rf
                   +1*pred_valid_kfold
                   +4*pred_valid_lgb
                   +4*pred_valid_xgb
                   +1*pred_valid_ada
                   +1*pred_valid_lgb2)/12
#%%
temp = predict_proba_to_predict(pred_valid_soft,valid_acc_id)
temp2 = valid_acc_id.merge(temp,how='left',on='acc_id')
print(accuracy_score(temp2['label'],valid['label']))

#%% 제출파일 생성
pred_test_soft = (2*pred_test_paste_rf
                   +3*pred_test_kfold
                   +2*pred_test_lgb
                   +1*pred_test_xgb
                   +3*pred_test_ada
                   +5*pred_test_lgb2)/16
#%%
temp = predict_proba_to_predict(pred_test_soft,test_acc_id)
temp2 = test_acc_id.merge(temp,how='left',on='acc_id')
last=temp2[['acc_id','label']]
last.to_csv(path+'/submission/softvoting_pred.csv',index=False)
