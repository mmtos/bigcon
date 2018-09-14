#%%
import gc
import numpy as np
import pandas as pd
import sys
path = 'C:/Users/jsh/Desktop/game'
sys.path.append(path)
from lightgbm import LGBMClassifier
#%%
train_pca = pd.read_csv(path+'/total/train0910_pca.csv')
test_pca = pd.read_csv(path+'/total/test0910_pca.csv')
#%%
from sklearn.model_selection import KFold

folds = KFold(n_splits= 4, shuffle=True, random_state=1001)
oof_preds = np.empty((train_pca.shape[0],4))
sub_preds = np.empty((test_pca.shape[0],4))
feature_importance_data = pd.DataFrame()
feats = [f for f in train_pca.columns if f not in ['label','acc_id']]
#%%
for n_fold, (train_idx, valid_idx) in enumerate(folds.split(train_pca[feats], train_pca['label'])):
    print('fold_number : ',n_fold)
    
    train_x, train_y = train_pca[feats].iloc[train_idx], train_pca['label'].iloc[train_idx]
    valid_x, valid_y = train_pca[feats].iloc[valid_idx], train_pca['label'].iloc[valid_idx]
    
    clf = LGBMClassifier(
        objective = 'multi:softmax',
        num_class = 4,
        booster = "gbtree",
        nthread=4,
        eval_metric = 'mlogloss', 
        n_estimators=10000,
        learning_rate=0.02,
        colsample_bytree=0.8,
        subsample=0.8,
        max_depth=8,
        reg_alpha=0.041545473,
        reg_lambda=0.0735294)
    
    clf.fit(train_x, train_y, eval_set=[(train_x, train_y), (valid_x, valid_y)], eval_metric= 'multi_logloss', verbose= 100, early_stopping_rounds=200)
    oof_preds[valid_idx] = clf.predict_proba(valid_x)
    
    sub_preds += clf.predict_proba(test_pca[feats])/ folds.n_splits

    fold_importance_data = pd.DataFrame()
    fold_importance_data["feature"] = feats
    fold_importance_data["importance"] = clf.feature_importances_
    fold_importance_data["fold"] = n_fold + 1
    feature_importance_data = pd.concat([feature_importance_data, fold_importance_data], axis=0)
 
    del train_x, train_y, valid_x, valid_y
    gc.collect()
#%%
sub_preds2=pd.DataFrame(sub_preds)
test_pca2=pd.DataFrame(test_pca['acc_id'])
test_pca2.reset_index(inplace=True)
del test_pca2['index']
test_proba=pd.concat([test_pca2,sub_preds2],axis=1)
test_proba.columns = ['acc_id','2month','month','retained','week']
test_proba_melted = pd.melt(test_proba,id_vars=['acc_id'],var_name='label')

num_agg={'value':['max']}
test_proba_melted_agg = test_proba_melted.groupby('acc_id').agg(num_agg)
test_proba_melted_agg.reset_index(inplace=True)
test_proba_melted_agg.columns = ['acc_id','value2']    
predict=test_proba_melted.merge(test_proba_melted_agg,how='left',on='acc_id')
predict_last=predict.loc[predict['value']==predict['value2'],]
del predict_last['value'],predict_last['value2']
#%%
predict_last.to_csv(path+'/submission/kfoldlabel.csv',index=False)
sub_preds2.to_csv(path+'/submission/kfoldproba.csv',index=False)
oof_preds2=pd.DataFrame(oof_preds)
oof_preds2.to_csv(path+'/submission/kfoldoofproba.csv',index=False)
