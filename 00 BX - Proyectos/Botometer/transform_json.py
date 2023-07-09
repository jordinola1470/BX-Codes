#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul  2 01:48:49 2021

@author: JOSE
"""

import json
import numpy as np
import pandas as pd

  
# Opening JSON file
path = r'C:\Users\JOSE\Desktop\Trabajo\BX\Botometer\autores agosto 1.json'
f = open(path,)
  
data = json.load(f)
  

df = pd.DataFrame(data[0])
df['data'] = df.apply(lambda row: row['categories'] if pd.isnull(row['user']) else row['user'], axis=1)
for col in ['scores', 'analysis']:
    df['data'] = df.apply(lambda row: row[col] if pd.isnull(row['data']) else row['data'], axis=1)
df = df.drop(['user', 'categories', 'scores', 'analysis'], axis = 1)
df = df.T
temp = pd.DataFrame(df.iloc[1,:4]).reset_index(drop=True)
df = df.reset_index(drop=True)
df = pd.concat([df, temp], axis=1)
df = pd.DataFrame(df.iloc[3,:]).T

for i in range(1, len(data)):
    base = pd.DataFrame(data[i])
    base['data'] = base.apply(lambda row: row['categories'] if pd.isnull(row['user']) else row['user'], axis=1)
    for col in ['scores', 'analysis']:
        base['data'] = base.apply(lambda row: row[col] if pd.isnull(row['data']) else row['data'], axis=1)
    base = base.drop(['user', 'categories', 'scores', 'analysis'], axis = 1)
    base = base.T
    temp = pd.DataFrame(base.iloc[1,:4]).reset_index(drop=True)
    base = base.reset_index(drop=True)
    base = pd.concat([base, temp], axis=1)
    base = pd.DataFrame(base.iloc[3,:]).T
    df = pd.concat([df, base])
    

path = r"C:\Users\JOSE\Desktop\Trabajo\BX\Botometer"
for h in range(1, 5):
    file_path = ''.join([path, '/autores agosto ', str(h), '.json'])
    print(file_path)
    f = open(file_path,)
    data = json.load(f)
    
    for i in range(len(data)):
        base = pd.DataFrame(data[i])
        base['data'] = base.apply(lambda row: row['categories'] if pd.isnull(row['user']) else row['user'], axis=1)
        for col in ['scores', 'analysis']:
            base['data'] = base.apply(lambda row: row[col] if pd.isnull(row['data']) else row['data'], axis=1)
        base = base.drop(['user', 'categories', 'scores', 'analysis'], axis = 1)
        base = base.T
        temp = pd.DataFrame(base.iloc[1,:4]).reset_index(drop=True)
        base = base.reset_index(drop=True)
        base = pd.concat([base, temp], axis=1)
        base = pd.DataFrame(base.iloc[3,:]).T
        df = pd.concat([df, base])

df = df.reset_index(drop = True)
df.to_excel(''.join([path, '/base_bm.xlsx']), index=True)       
original = pd.read_excel('agosto_22_23_BM.xlsx')      
bots = pd.read_excel('base_bm.xlsx')
base_merge = pd.merge(original, bots, how='left', left_on='autores', right_on='screen_name')


base_merge = base_merge.drop_duplicates(subset =['autores'] )
recortada = base_merge[['autores','capScore']]
recortada = recortada.rename(columns={"autores": "Autores", "capScore": "Valores"})
recortada["Valores"] = round(recortada["Valores"] * 100)
base_1 = pd.read_excel("base_p1.xlsx")
final_merge = base_1.append(recortada)
final_merge.to_excel("Base_completa.xlsx")
recortada.to_excel("Base_mitad_2_bm.xlsx")
base_merge.to_excel('Base_bm_merge_final.xlsx')        
        