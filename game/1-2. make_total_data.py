#%%
import pandas as pd
import sys
path = 'C:/Users/jsh/Desktop/game'
sys.path.append(path)
#%% activity version1(전체 그룹화)
train_act = pd.read_csv(path+'/train/train_activity.csv')
test_act = pd.read_csv(path+'/test/test_activity.csv')

act = pd.concat([train_act,test_act])
act = act.reset_index()
del act['index']

num_columns = list(act.columns[act.dtypes != 'object'])
num_agg={}
for col in num_columns:
    num_agg[col]=['median','max','min']
del num_agg['wk']

act_agg = act.groupby('acc_id').agg(num_agg)
act_agg.columns = pd.Index(['ACT_'+e[0]+"_"+e[1].upper() for e in act_agg.columns.tolist()])
act_agg= act_agg.reset_index()
act_agg.to_csv(path+'/group/act_agg.csv',index=False)
#%% activity version2(주차별 원데이터)
train_act = pd.read_csv(path+'/train/train_activity.csv')
test_act = pd.read_csv(path+'/test/test_activity.csv')

act = pd.concat([train_act,test_act])
act = act.reset_index()
del act['index']

#pivot_table()
temp=act
valuelist=[e for e in act.columns.tolist() if e not in ['acc_id','wk'] ]
temp=temp.pivot_table(values=valuelist, index='acc_id', columns='wk')
temp.columns = pd.Index([e[0]+"_Week"+str(e[1]) for e in temp.columns.tolist()])
temp.reset_index(inplace=True)
temp.to_csv(path+'/group/act_by_oneweek.csv',index=False)

#%% activity version3 (부분 그룹화)
train_act = pd.read_csv(path+'/train/train_activity.csv')
test_act = pd.read_csv(path+'/test/test_activity.csv')

act = pd.concat([train_act,test_act])
act = act.reset_index()
del act['index']
act12=act.loc[(act['wk']==1) | (act['wk']==2)]
act34=act.loc[(act['wk']==3) | (act['wk']==4)]
act56=act.loc[(act['wk']==5) | (act['wk']==6)]
act78=act.loc[(act['wk']==7) | (act['wk']==8)]

num_columns = list(act.columns[act.dtypes != 'object'])
num_agg={}
for col in num_columns:
    num_agg[col]=['median','max','min']
del num_agg['wk']

act12_agg = act12.groupby('acc_id').agg(num_agg)
act34_agg = act34.groupby('acc_id').agg(num_agg)
act56_agg = act56.groupby('acc_id').agg(num_agg)
act78_agg = act78.groupby('acc_id').agg(num_agg)


act12_agg.columns = pd.Index(['ACTW12_'+e[0]+"_"+e[1].upper() for e in act12_agg.columns.tolist()])
act34_agg.columns = pd.Index(['ACTW34_'+e[0]+"_"+e[1].upper() for e in act34_agg.columns.tolist()])
act56_agg.columns = pd.Index(['ACTW56_'+e[0]+"_"+e[1].upper() for e in act56_agg.columns.tolist()])
act78_agg.columns = pd.Index(['ACTW78_'+e[0]+"_"+e[1].upper() for e in act78_agg.columns.tolist()])

act12_agg.reset_index(inplace=True)
act34_agg.reset_index(inplace=True)
act56_agg.reset_index(inplace=True)
act78_agg.reset_index(inplace=True)

act12_agg.to_csv(path+'/group/act12_agg.csv',index=False)
act34_agg.to_csv(path+'/group/act34_agg.csv',index=False)
act56_agg.to_csv(path+'/group/act56_agg.csv',index=False)
act78_agg.to_csv(path+'/group/act78_agg.csv',index=False)

#%%
train_guild_acc_id = pd.read_csv(path+'/train/train_guild.csv',usecols=['guild_member_acc_id'])
test_guild_acc_id = pd.read_csv(path+'/test/test_guild.csv',usecols=['guild_member_acc_id'])

guild= pd.concat([train_guild_acc_id,test_guild_acc_id])
guild = guild.reset_index()
del guild['index']

temp=pd.concat([pd.Series(1,row['guild_member_acc_id'].split(',')) for _,row in guild.iterrows()]).reset_index()
temp.columns = ['acc_id','guild_count']
guild_agg=temp.groupby('acc_id').agg({'guild_count':'sum'})
guild_agg=guild_agg.reset_index()
guild_agg.to_csv(path+'/group/guild_agg.csv',index=False)

#%%
train_party_hashed = pd.read_csv(path+'/train/train_party.csv',usecols=['hashed'])
test_party_hashed = pd.read_csv(path+'/test/test_party.csv',usecols=['hashed'])
temp1 = train_party_hashed[0:1000000]
temp2 = train_party_hashed[1000000:2000000]
temp3 = train_party_hashed[2000000:3000000]
temp4 = train_party_hashed[3000000:4000000]
temp5 = train_party_hashed[4000000:5000000]
temp6 = train_party_hashed[5000000:6000000]
temp7 = train_party_hashed[6000000:6962341]
temp8 = test_party_hashed[0:1000000]
temp9 = test_party_hashed[1000000:2000000]
temp10 = test_party_hashed[2000000:3000000]
temp11 = test_party_hashed[3000000:4000000]
temp12 = test_party_hashed[4000000:4121512]
del train_party_hashed,test_party_hashed

def party_agg(df):
    splited = pd.concat([pd.Series(1,row['hashed'].split(',')) for _,row in df.iterrows()]).reset_index()
    splited.columns = ['acc_id','party_count']
    grouped=splited.groupby('acc_id').agg({'party_count':'sum'})
    grouped=grouped.reset_index()
    return grouped
grouped1 = party_agg(temp1)
grouped2 = party_agg(temp2)
grouped3 = party_agg(temp3)
grouped4 = party_agg(temp4)
grouped5 = party_agg(temp5)
grouped6 = party_agg(temp6)
grouped7 = party_agg(temp7)
grouped8 = party_agg(temp8)
grouped9 = party_agg(temp9)
grouped10 = party_agg(temp10)
grouped11 = party_agg(temp11)
grouped12 = party_agg(temp12)
del temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9,temp10,temp11,temp12
grouped = pd.concat([grouped1,grouped2,grouped3,grouped4,
                     grouped5,grouped6,grouped7,grouped8,
                     grouped9,grouped10,grouped11,grouped12])
grouped_agg =grouped.groupby('acc_id').agg({'party_count':'sum'})
grouped_agg=grouped_agg.reset_index()
grouped_agg.to_csv(path+'/group/party_agg.csv',index=False)
#%%
train_payment = pd.read_csv(path+'/train/train_payment.csv')
test_payment = pd.read_csv(path+'/test/test_payment.csv')
payment= pd.concat([train_payment,test_payment])
payment = payment.reset_index()
del payment['index']

payment['week_weight']=0
payment.loc[payment['payment_amount'] > -0.14, 'week_weight'] = 1

payment['payment_week_real']=payment['week_weight']*payment['payment_week']
num_agg = {'payment_week_real':['sum'],'payment_amount':['sum','max','min']}
payment_agg = payment.groupby('acc_id').agg(num_agg)
payment_agg.columns = pd.Index(['PAYMENT_'+e[0]+"_"+e[1].upper() for e in payment_agg.columns.tolist()])
payment_agg= payment_agg.reset_index()
payment_agg.to_csv(path+'/group/payment_agg.csv',index=False)
#%% trade version1
train_trade=pd.read_csv(path+'/train/train_trade.csv')
test_trade = pd.read_csv(path+'/test/test_trade.csv')
trade = pd.concat([train_trade,test_trade])
trade = trade.reset_index()
del trade['index']
trade['count']=1
num_agg={'count':['sum']}
trade_source_agg = trade.groupby('source_acc_id').agg(num_agg)
trade_source_agg.columns = pd.Index(['TRADE_source_'+e[0]+"_"+e[1].upper() for e in trade_source_agg.columns.tolist()])
trade_source_agg=trade_source_agg.reset_index()
trade_source_agg['acc_id']=trade_source_agg.pop('source_acc_id')

trade_target_agg =trade.groupby('target_acc_id').agg(num_agg)
trade_target_agg.columns = pd.Index(['TRADE_target_'+e[0]+"_"+e[1].upper() for e in trade_target_agg.columns.tolist()])
trade_target_agg=trade_target_agg.reset_index()
trade_target_agg['acc_id']=trade_target_agg.pop('target_acc_id')

trade_agg = trade_source_agg.merge(trade_target_agg,how='outer',on='acc_id')
trade_agg=trade_agg.fillna(0)
trade_agg.to_csv(path+'/group/trade_agg.csv',index=False)

#%% trade version2 :품목별 count, amount 추가
train_trade=pd.read_csv(path+'/train/train_trade.csv')
test_trade = pd.read_csv(path+'/test/test_trade.csv')
trade = pd.concat([train_trade,test_trade])
trade = trade.reset_index()
del trade['index'],test_trade,train_trade
#원핫 인코딩
trade= pd.get_dummies(trade, columns=['item_type'])
#품목별 ammount
trade['accessory_amount']=trade['item_type_accessory']*trade['item_amount']
trade['costume_amount']=trade['item_type_costume']*trade['item_amount']
trade['gem_amount']=trade['item_type_gem']*trade['item_amount']
trade['grocery_amount']=trade['item_type_grocery']*trade['item_amount']
trade['money_amount']=trade['item_type_money']*trade['item_amount']
trade['weapon_amount']=trade['item_type_weapon']*trade['item_amount']

num_agg={}
#품목별 count 그룹화
num_columns=trade.columns[6:12]
for col in num_columns:
    num_agg[col]=['sum']
#품목별 amount 그룹화
num_columns=trade.columns[12:19]
for col in num_columns:
    num_agg[col]=['sum','max','mean']

trade_source_agg = trade.groupby(['source_acc_id']).agg(num_agg)
trade_source_agg.columns = pd.Index(['TRADE_source_'+e[0]+"_"+e[1].upper() for e in trade_source_agg.columns.tolist()])
trade_source_agg=trade_source_agg.reset_index()
trade_source_agg.rename(columns = {'source_acc_id':'acc_id'}, inplace = True)

trade_target_agg =trade.groupby('target_acc_id').agg(num_agg)
trade_target_agg.columns = pd.Index(['TRADE_target_'+e[0]+"_"+e[1].upper() for e in trade_target_agg.columns.tolist()])
trade_target_agg=trade_target_agg.reset_index()
trade_target_agg.rename(columns = {'target_acc_id':'acc_id'}, inplace = True)
del trade

trade_agg = trade_source_agg.merge(trade_target_agg,how='outer',on='acc_id')
trade_agg=trade_agg.fillna(0)
trade_agg.to_csv(path+'/group/trade_agg2.csv',index=False)

#%% trade version3 : grocery 시계열관련 변수 추출(use_tsfresh.py에서 시도)

#%% trainset, testset 생성
party=pd.read_csv(path+'/group/party_agg.csv')
trade2=pd.read_csv(path+'/group/trade_agg2.csv')
trade=pd.read_csv(path+'/group/trade_agg.csv')
guild=pd.read_csv(path+'/group/guild_agg.csv')
payment=pd.read_csv(path+'/group/payment_agg.csv')
act_agg =pd.read_csv(path+'/group/act_agg.csv')
train_label=pd.read_csv(path+'/train/train_label.csv')
test=pd.read_csv(path+'/test/test_activity.csv')
test_id= pd.DataFrame(test['acc_id'].unique(),columns=['acc_id'])
test_id.to_csv(path+'/test/test_id.csv',index=False)
#%%
train =train_label.merge(act_agg,how='left',on='acc_id')
train =train.merge(party,how='left',on='acc_id')
train =train.merge(trade2,how='left',on='acc_id')
train =train.merge(trade,how='left',on='acc_id')
train =train.merge(guild,how='left',on='acc_id')
train =train.merge(payment,how='left',on='acc_id')

test =test_id.merge(act_agg,how='left',on='acc_id')
test =test.merge(party,how='left',on='acc_id')
test =test.merge(trade2,how='left',on='acc_id')
test =test.merge(trade,how='left',on='acc_id')
test =test.merge(guild,how='left',on='acc_id')
test =test.merge(payment,how='left',on='acc_id')

#%%
train.to_csv(path+'/total/trainset.csv',index=False)
test.to_csv(path+'/total/testset.csv',index=False)

#%% trainset0910, testset0910 생성
party=pd.read_csv(path+'/group/party_agg.csv')
trade=pd.read_csv(path+'/group/trade_agg.csv')
trade2=pd.read_csv(path+'/group/trade_agg2.csv')
guild=pd.read_csv(path+'/group/guild_agg.csv')
payment=pd.read_csv(path+'/group/payment_agg.csv')
act_agg =pd.read_csv(path+'/group/act_agg.csv')
act12_agg =pd.read_csv(path+'/group/act12_agg.csv')
act34_agg =pd.read_csv(path+'/group/act34_agg.csv')
act56_agg =pd.read_csv(path+'/group/act56_agg.csv')
act78_agg =pd.read_csv(path+'/group/act78_agg.csv')
act_oneweek =pd.read_csv(path+'/group/act_by_oneweek.csv')

trade_ts_for_train=pd.read_csv(path+'/tsfresh/trade_ts_for_train.csv')
trade_ts_for_test=pd.read_csv(path+'/tsfresh/trade_ts_for_test.csv')
del trade_ts_for_train['acc_id.1'],trade_ts_for_test['acc_id.1']

train_label=pd.read_csv(path+'/train/train_label.csv')
test=pd.read_csv(path+'/test/test_activity.csv')
test_id= pd.DataFrame(test['acc_id'].unique(),columns=['acc_id'])
test_id.to_csv(path+'/test/test_id.csv',index=False)
#%%
train =train_label.merge(act_agg,how='left',on='acc_id')
train =train.merge(act12_agg,how='left',on='acc_id')
train =train.merge(act34_agg,how='left',on='acc_id')
train =train.merge(act56_agg,how='left',on='acc_id')
train =train.merge(act78_agg,how='left',on='acc_id')
train =train.merge(act_oneweek,how='left',on='acc_id')
train =train.merge(party,how='left',on='acc_id')
train =train.merge(trade,how='left',on='acc_id')
train =train.merge(trade2,how='left',on='acc_id')
train =train.merge(guild,how='left',on='acc_id')
train =train.merge(payment,how='left',on='acc_id')
train = train.merge(trade_ts_for_train,how='left',on='acc_id')

test =test_id.merge(act_agg,how='left',on='acc_id')
test =test.merge(act12_agg,how='left',on='acc_id')
test =test.merge(act34_agg,how='left',on='acc_id')
test =test.merge(act56_agg,how='left',on='acc_id')
test =test.merge(act78_agg,how='left',on='acc_id')
test =test.merge(act_oneweek,how='left',on='acc_id')
test =test.merge(party,how='left',on='acc_id')
test =test.merge(trade,how='left',on='acc_id')
test =test.merge(trade2,how='left',on='acc_id')
test =test.merge(guild,how='left',on='acc_id')
test =test.merge(payment,how='left',on='acc_id')
test = test.merge(trade_ts_for_test,how='left',on='acc_id')

#%%
train.to_csv(path+'/total/trainset0910.csv',index=False)
test.to_csv(path+'/total/testset0910.csv',index=False)
