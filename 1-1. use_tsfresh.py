import numpy as np
import pandas as pd
import sys
path = 'C:/Users/jsh/Desktop/game'
sys.path.append(path)
from tsfresh.feature_extraction import extract_features
from tsfresh import select_features
#%%
train_trade=pd.read_csv(path+'/train/train_trade.csv')
test_trade = pd.read_csv(path+'/test/test_trade.csv')
trade = pd.concat([train_trade,test_trade])
trade = trade.reset_index()
del trade['index']
#원핫 인코딩
trade= pd.get_dummies(trade, columns=['item_type'])
#품목별 ammount
trade['accessory_amount']=trade['item_type_accessory']*trade['item_amount']
trade['costume_amount']=trade['item_type_costume']*trade['item_amount']
trade['gem_amount']=trade['item_type_gem']*trade['item_amount']
trade['grocery_amount']=trade['item_type_grocery']*trade['item_amount']
trade['money_amount']=trade['item_type_money']*trade['item_amount']
trade['weapon_amount']=trade['item_type_weapon']*trade['item_amount']
del train_trade,test_trade
trade_source=trade[['trade_week','source_acc_id','accessory_amount','costume_amount','gem_amount','grocery_amount','money_amount','weapon_amount']]
trade_target=trade[['trade_week','target_acc_id','accessory_amount','costume_amount','gem_amount','grocery_amount','money_amount','weapon_amount']]
del trade

train_label=pd.read_csv(path+'/train/train_label.csv')
extract_source_train=train_label.merge(trade_source,how='left',left_on='acc_id',right_on='source_acc_id')
del extract_source_train['source_acc_id'],extract_source_train['label']
extract_source_train.to_csv(path+'/tsfresh/extract_source_train.csv',index=False)

test_id=pd.read_csv(path+'/test/test_id.csv')
extract_source_test=test_id.merge(trade_source,how='left',left_on='acc_id',right_on='source_acc_id')
del extract_source_test['source_acc_id']
extract_source_test.to_csv(path+'/tsfresh/extract_source_test.csv',index=False)
del trade_source

extract_target_train=train_label.merge(trade_target,how='left',left_on='acc_id',right_on='target_acc_id')
del extract_target_train['target_acc_id'],extract_target_train['label']
extract_target_train.to_csv(path+'/tsfresh/extract_target_train.csv',index=False)

extract_target_test=test_id.merge(trade_target,how='left',left_on='acc_id',right_on='target_acc_id')
del extract_target_test['target_acc_id']
extract_target_test.to_csv(path+'/tsfresh/extract_target_test.csv',index=False)
del trade_target

#%%데이터 준비
extract_source_train=pd.read_csv(path+'/tsfresh/extract_source_train.csv')
extract_source_train=extract_source_train.fillna(0)

extract_source_test=pd.read_csv(path+'/tsfresh/extract_source_test.csv')
extract_source_test=extract_source_test.fillna(0)

extract_target_train=pd.read_csv(path+'/tsfresh/extract_target_train.csv')
extract_target_train=extract_target_train.fillna(0)

extract_target_test=pd.read_csv(path+'/tsfresh/extract_target_test.csv')
extract_target_test=extract_target_test.fillna(0)
train_label=pd.read_csv(path+'/train/train_label.csv')
y=train_label['label']
y.index=pd.Index(list(train_label['acc_id']))
#%%source,target에 대해 각각 train에 넣을 시계열변수를 생성하고 골라냄. test에도 넣어야 하므로 
fc_parameters = {
    "length": None,
    "standard_deviation":None,
    "count_above_mean":None,
    "count_below_mean":None,
    "first_location_of_maximum":None,
    "first_location_of_minimum":None,
    "quantile":[{"q":0.5}],
    "number_peaks":[{"n":1}],
    "large_standard_deviation": [{"r": 0.05}, {"r": 0.1}]
}
#%%
ef_source= extract_features(extract_source_train,
                      column_id="acc_id",
                      column_sort="trade_week",
                      chunksize=1,
                      default_fc_parameters=fc_parameters,
                      disable_progressbar=True,
                      n_jobs=4)
ef_source.to_csv(path+'/tsfresh/ef_source.csv',index=False)
#%%
ef_source_filtered = select_features(ef_source, y)
ef_source_filtered= ef_source_filtered.reset_index()
ef_source_filtered.rename(columns = {'id':'acc_id'}, inplace = True)
ef_source_filtered.to_csv(path+'/tsfresh/trade_ts_for_train_source.csv',index=False)
feats=[f for f in ef_source_filtered.columns if f not in ['acc_id']]
#%%
ef_source_test= extract_features(extract_source_test,
                      column_id="acc_id",
                      column_sort="trade_week",
                      chunksize=1,
                      default_fc_parameters=fc_parameters,
                      disable_progressbar=True,
                      n_jobs=4)
#%%중간저장
ef_source_test.to_csv(path+'/tsfresh/ef_source_test.csv',index=False)

#%%
ef_source_test=ef_source_test[feats]
ef_source_test=ef_source_test.reset_index()
ef_source_test.rename(columns = {'id':'acc_id'}, inplace = True)
ef_source_test.to_csv(path+'/tsfresh/trade_ts_for_test_source.csv',index=False)
del extract_source_train,extract_source_test

#%%
ef_target= extract_features(extract_target_train,
                      column_id="acc_id",
                      column_sort="trade_week",
                      chunksize=1,
                      default_fc_parameters=fc_parameters,
                      disable_progressbar=True,
                      n_jobs=4)
ef_target.to_csv(path+'/tsfresh/ef_target.csv',index=False)
#%%
ef_target_filtered = select_features(ef_target, y)
ef_target_filtered= ef_target_filtered.reset_index()
ef_target_filtered.rename(columns = {'id':'acc_id'}, inplace = True)
ef_target_filtered.to_csv(path+'/tsfresh/trade_ts_for_train_target.csv',index=False)
feats=[f for f in ef_target_filtered.columns if f not in ['acc_id']]
#%%
ef_target_test= extract_features(extract_target_test,
                      column_id="acc_id",
                      column_sort="trade_week",
                      chunksize=1,
                      default_fc_parameters=fc_parameters,
                      disable_progressbar=True,
                      n_jobs=4)
ef_target_test.to_csv(path+'/tsfresh/ef_target_test.csv',index=False)
#%%
ef_target_test=ef_target_test[feats]
ef_target_test=ef_target_test.reset_index()
ef_target_test.rename(columns = {'id':'acc_id'}, inplace = True)
ef_target_test.to_csv(path+'/tsfresh/trade_ts_for_test_target.csv',index=False)

#%%
trade_ts_for_train = pd.concat([ef_source_filtered,ef_target_filtered],axis=1)
trade_ts_for_test = pd.concat([ef_source_test,ef_target_test],axis=1)
trade_ts_for_train.to_csv(path+'/tsfresh/trade_ts_for_train.csv',index=False)
trade_ts_for_test.to_csv(path+'/tsfresh/trade_ts_for_test.csv',index=False)

