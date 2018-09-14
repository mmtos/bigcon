#%%
import pandas as pd
import sys
import pickle
path = 'C:/Users/jsh/Desktop/game'
sys.path.append(path)

#%%
from sklearn.metrics import accuracy_score
from lightgbm import LGBMClassifier
#%%
train_pca = pd.read_csv(path+'/total/train0910_pca.csv')
test_pca = pd.read_csv(path+'/total/test0910_pca.csv')
#%%
from sklearn.model_selection import StratifiedShuffleSplit

split = StratifiedShuffleSplit(n_splits=1, test_size = 0.2, random_state=123)
for train_index, valid_index in split.split(train_pca, train_pca["label"]):
    train,valid = train_pca.loc[train_index], train_pca.loc[valid_index]
    feats = [f for f in train_pca.columns if f not in ['acc_id','label']]
    train_x=train[feats]
    train_y=train['label']
    valid_x=valid[feats]
    valid_y=valid['label']
 #%%   
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
#%%
#학습하여 모델 생성(100라운드마다 평가지표 로그 출력)
clf.fit(train_x, train_y, eval_set=[(train_x, train_y), (valid_x, valid_y)], eval_metric= 'multi_logloss', verbose= 100, early_stopping_rounds=200)
pickle.dump(clf, open("lgb_pca6.pickle", "wb"))
#%%
pred_valid_label=list(clf.predict(valid_x))
print('Accuracy_score %.6f' % accuracy_score(valid_y, pred_valid_label))

#%% 학습된 모델 불러오기
clf2 = pickle.load(open("lgb_pca6.pickle", "rb"))
pred_valid_label=list(clf2.predict(valid_x))
print('Accuracy_score %.6f' % accuracy_score(valid_y, pred_valid_label))

feats = [f for f in train_pca.columns if f not in ['acc_id','label']]
importance_data = pd.DataFrame()
importance_data["feature"] = feats
importance_data["importance"] = clf2.feature_importances_
#%%
from sklearn.metrics import confusion_matrix
import matplotlib.pyplot as plt
#2month, month, retained, week 순 입니다.
cm=confusion_matrix(valid_y,pred_valid_label)
plt.matshow(cm,cmap=plt.cm.gray)
plt.show()
