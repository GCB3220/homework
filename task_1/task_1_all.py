import re
import pandas as pd

df = pd.read_excel('C:/a/y-code/python1/file/TO_GCB.xlsx')

# 根据ss_distribution判断序列起始和终结
ss_d = df['ss_distribution'].tolist()
df['end'] = None
df['start'] = None
for i in range(len(ss_d)):
    ss_di = ss_d[i].split(';')
    start = re.search(r'(\S+)-', ss_di[0]).group(1)
    df.at[i, 'start'] = start
    end = re.search(r'-(\d+)', ss_di[-1]).group(1)
    df.at[i, 'end'] = end

#判断是否替换数字
def replace(column_name):
    lis = df.loc[0, column_name].split(";")
    start_1 = int(df.loc[0, 'start'])
    end_1 = int(df.loc[0, 'end'])
    # check head
    match_head = re.search(r'\d-(.+)\s', lis[0])# \s:space
    if match_head:
        if int(match_head.group(1))+1 == start_1:
            lis[0] = re.sub(r'.+\d', "head", lis[0])
    else: lis[0] = re.sub(r'.+\d', "head", lis[0])# simple number
    # check tail
    match_tail = re.search(r'(.\d+)-', lis[-1])
    if match_tail:
        if int(match_tail.group(1))-1 == end_1:
            lis[-1] = re.sub(r'.+\d', "tail", lis[-1])
    else:
        lis[-1] = re.sub(r'.+\d', "tail", lis[-1])

    df.at[0, column_name] = '; '.join(str(i) for i in lis)
    return df

column = ['ins_q', 'ins_m', 'del_q', 'del_m']
replace(column[0])
replace(column[1])
replace(column[2])
replace(column[3])

#写进excel
df.to_excel('C:/a/y-code/python1/file/A.xlsx', index=False)
