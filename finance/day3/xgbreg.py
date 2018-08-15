# -*- coding: utf-8 -*-
"""
Created on Fri Aug 10 10:42:54 2018

@author: User
"""
#%%
import numpy as np
import pandas as pd
import xgboost as xgb
from sklearn import cross_validation
from sklearn.metrics import explained_variance_score,mean_squared_error,r2_score
from sys import path
path.append('C:\\Users\\User\\XGBReg')
print(path)
#%%
data = pd.read_csv('C:\\Users\\User\\XGBReg/input/kc_house_data.csv')
y = data['price']
X=data.drop('price',axis=1)
#%%
X_train, X_test, y_train, y_test = cross_validation.train_test_split(X, y ,test_size=0.2)
excluded_feats = ['id','date']
features = [f_ for f_ in X.columns if f_ not in excluded_feats]
X_train = X_train[features]
X_test = X_test[features]
#%%
clf = xgb.XGBRegressor(
         n_estimators=100, 
         learning_rate=0.08, 
         gamma=0, 
         subsample=0.75,
         colsample_bytree=1,
         max_depth=7
)
clf.fit(X_train,y_train)
predicted = clf.predict(X_test)
print(explained_variance_score(predicted,y_test))
print(mean_squared_error(predicted,y_test))
print(r2_score(predicted,y_test))