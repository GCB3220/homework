import pandas as pd

read_file = 'C:/a/y-code/python1/z_task_6/seqInfo.csv'
data_file = 'C:/a/y-code/python1/z_task_6/pairInfo.csv'
out_file = 'C:/a/y-code/python1/z_task_6/out_problems.csv'
data_f = pd.read_csv(data_file)
read_f = pd.read_csv(read_file)

del_head_q = data_f['delHeadQ']
del_tail_q = data_f['delTailQ']
del_head_m = data_f['delHeadM']
del_tail_m = data_f['delTailM']
ins_head_q = data_f['insHeadQ']
ins_tail_q = data_f['insTailQ']
ins_head_m = data_f['insHeadM']
ins_tail_m = data_f['insTailM']


def check(df):
    special_lis = []
    for i in range(len(df)):
        if type(df[i]) != str:
            special_lis.append(i)

    return special_lis


a = check(del_tail_q)
b = check(del_head_q)
c = check(del_tail_m)
d = check(del_head_m)
e = check(ins_tail_m)
f = check(ins_head_m)
g = check(ins_head_q)
h = check(ins_tail_q)

x = a+b+c+d+e+f+g+h
z = []

x = list(set(x))

for i in x:
    z.append(data_f['pair'][i])


df = pd.DataFrame(z, columns=['pair'])
df.to_csv(out_file, index=False)