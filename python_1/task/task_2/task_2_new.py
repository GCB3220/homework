import re
from pprint import pprint
import pandas as pd

df = pd.read_csv('C:/a/y-code/python1/file/pdb_info_to_gcb.csv', keep_default_na=False)

df['pdb_id'] = df['pdb_id'].astype(str)
dict_new = {}
column = df['pdb_id'].astype(str)
for i in column:
    if re.search(r'\+', i):
        z = i[0]+i[4]+i[6]+i[7]
        dict_new[i] = z
    elif re.search(r'-', i):
        z = i[0]+i[2]+i[3]+i[4]
        z = z.upper()
        dict_new[i] = z

df['pdb_id'] = df['pdb_id'].replace(dict_new)
df.to_csv('C:/a/y-code/python1/file/new.csv', index=False)