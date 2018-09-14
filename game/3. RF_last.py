#%%
import matplotlib.pyplot as plt
import pandas as pd
import sys
import pickle
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import ExtraTreesClassifier
from sklearn.metrics import accuracy_score
path = 'C:/Users/jsh/Desktop/game'
sys.path.append(path)
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
paste_clf = RandomForestClassifier(n_estimators = 200,
                                 random_state=42,
                                 n_jobs = -1,
                                 verbose=10,
                                 bootstrap=False)
paste_clf.fit(train_x,train_y)
pickle.dump(paste_clf, open("rf.pickle", "wb"))
#%%
pred_valid_label = paste_clf.predict(valid_x)
print(paste_clf.__class__.__name__, accuracy_score(valid_y,pred_valid_label))
#%%
bag_clf = RandomForestClassifier(n_estimators = 300,
                                 random_state=42,
                                 n_jobs = -1,
                                 verbose=10,
                                 bootstrap=True,
                                 oob_score=True,
                                 )
bag_clf.fit(train_x,train_y)
pickle.dump(bag_clf, open("bag_rf.pickle", "wb"))
#%%
pred_valid_label = bag_clf.predict(valid_x)
print(bag_clf.__class__.__name__, accuracy_score(valid_y,pred_valid_label))

#%%
paste_clf = ExtraTreesClassifier(n_estimators = 200,
                                 random_state=42,
                                 n_jobs = -1,
                                 verbose=10,
                                 bootstrap=False,
                                 oob_score=False
                                 )
paste_clf.fit(train_x,train_y)
pickle.dump(paste_clf, open("extra.pickle", "wb"))
#%%
pred_valid_label = paste_clf.predict(valid_x)
print(paste_clf.__class__.__name__, accuracy_score(valid_y,pred_valid_label))

#%%
bag_clf = ExtraTreesClassifier(n_estimators = 400,
                                 random_state=42,
                                 n_jobs = -1,
                                 verbose=10,
                                 bootstrap=True,
                                 oob_score=True
                                 )
bag_clf.fit(train_x,train_y)
pickle.dump(bag_clf, open("bag_extra.pickle", "wb"))
#%%
pred_valid_label = bag_clf.predict(valid_x)
print(bag_clf.__class__.__name__, accuracy_score(valid_y,pred_valid_label))

#%%
clf2 = pickle.load(open("rf.pickle", "rb"))
pred_valid_label=list(clf2.predict(valid_x))
print('Accuracy_score %.6f' % accuracy_score(valid_y, pred_valid_label))

feats = [f for f in train_data.columns if f not in ['acc_id','label']]
importance_data = pd.DataFrame()
importance_data["feature"] = feats
importance_data["importance"] = clf2.feature_importances_

#%%
from sklearn.metrics import confusion_matrix
#2month, month, retained, week 순 입니다.
cm=confusion_matrix(valid_y,pred_valid_label)
plt.matshow(cm,cmap=plt.cm.gray)
plt.show()






