
import pandas as pd
import sys
path = 'C:/Users/jsh/Desktop/game'
sys.path.append(path)
from sklearn.preprocessing import MinMaxScaler
from sklearn.decomposition import PCA
#%% act 대거추가 및 trade time series 추가
train_data = pd.read_csv(path+'/total/trainset0910.csv')
test_data = pd.read_csv(path+'/total/testset0910.csv')
train_data = train_data.fillna(0)
test_data = test_data.fillna(0)
#%%
pca=PCA(n_components=0.99)
feats = [f for f in train_data.columns if f not in ['acc_id','label']]
train_label = train_data.pop('label')
traintest = pd.concat([train_data,test_data])
traintest=traintest.reset_index()
del traintest['index']
#%%
temp=traintest[feats]
scaler = MinMaxScaler()
temp=scaler.fit_transform(temp)
#%%
traintest_pca=pca.fit_transform(temp)
traintest_pca=pd.DataFrame(traintest_pca)
traintest_pca.columns=['PCA'+str(e) for e in list(traintest_pca.columns)] 
traintest_pca=pd.concat([traintest_pca,traintest['acc_id']],axis=1)
train_pca=traintest_pca[:100000]
test_pca=traintest_pca[100000:140000]
train_pca=pd.concat([train_pca,train_label],axis=1)

test_pca.to_csv(path+'/total/test0910_pca.csv', index= False)
train_pca.to_csv(path+'/total/train0910_pca.csv', index= False)
