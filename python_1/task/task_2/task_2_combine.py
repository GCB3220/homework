import re
import os
import pandas as pd

z = 0
data = []

for z in range(0, 203):
    a = f'C:/a/y-code/python1/file/update_1/{z}.csv'
    df = pd.read_csv(a, encoding='latin-1')
    data.append(df)

combined_df = pd.concat(data, ignore_index=True)
combined_df.to_csv('C:/a/y-code/python1/file/u.csv', index=False)

