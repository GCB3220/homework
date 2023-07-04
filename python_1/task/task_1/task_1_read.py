import re
import pandas as pd

df = pd.read_excel('C:/a/y-code/python1/file/TO_GCB.xlsx')

del_q_list = df.loc[0, 'del_q'].split(";")
ins_q_list = df.loc[0, 'ins_q'].split(";")
del_m_list = df.loc[0, 'del_m'].split(";")
ins_q_list = df.loc[0, 'ins_m'].split(";")


ss_d = df['ss_distribution'].tolist()
df['end'] = None
df['start'] = None
for i in range(len(ss_d)):
    ss_di = ss_d[i].split(';')
    start = re.search(r'(\S+)-', ss_di[0]).group(1)
    df.at[i, 'start'] = start
    end = re.search(r'-(\d+)', ss_di[-1]).group(1)
    df.at[i, 'end'] = end
#df.to_excel('C:/a/y-code/python1/file/A.xlsx', index=False)

start = int(df.loc[0, 'start'])
print(start)
