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
train_data = pd.read_csv(path+'/total/trainset.csv')
test_data = pd.read_csv(path+'/total/testset.csv')
#%% 계층추출
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
clf = LGBMClassifier(
    objective = 'multi:softmax',
    num_class = 4,
    booster = "gbtree",
    nthread=4,
    eval_metric = 'mlogloss', 
    n_estimators=10000,
    learning_rate=0.02,
    num_leaves=34,
    colsample_bytree=0.9497036,
    subsample=0.8715623,
    max_depth=8,
    reg_alpha=0.041545473,
    reg_lambda=0.0735294,
    min_split_gain=0.0222415,
    min_child_weight=39.3259775,
    silent=-1,
    verbose=-1)
#%%
clf.fit(train_x, train_y, eval_set=[(train_x, train_y), (valid_x, valid_y)], eval_metric= 'multi_logloss', verbose= 100, early_stopping_rounds=200)
pickle.dump(clf, open("lgb.pickle", "wb"))
#%%
pred_valid_label=list(clf.predict(valid_x))
print('Accuracy_score %.6f' % accuracy_score(valid_y, pred_valid_label))
#%% 학습된 모델 불러오기
clf2 = pickle.load(open("lgb.pickle", "rb"))
pred_valid_label=list(clf2.predict(valid_x))
print('Accuracy_score %.6f' % accuracy_score(valid_y, pred_valid_label))
feats = [f for f in train_data.columns if f not in ['acc_id','label']]
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