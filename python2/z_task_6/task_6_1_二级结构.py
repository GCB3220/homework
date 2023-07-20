import pandas as pd


# 读取/写入
readfile = 'C:/a/y-code/python2/task/task_6/seqInfo.csv'
outfile = 'C:/a/y-code/python2/task/task_6/out_ss.csv'
df = pd.read_csv(readfile)


# 得出二级结构
def check_seq(dataf):
    # 读取二级结构
    seq_data = dataf['dst_ss']

    # 识别
    for w in range(len(seq_data)):
        seq = seq_data[w]
        hlx_count = 0
        sht_count = 0
        old_ss = ''
        ss = []

        # 将二级结构中LSH放入一个列表中
        # 如: 'LLHHSS' 会变成列表['', 'LL', 'HH', 'SS']
        # 之后统计列表中有S和H的项的个数
        for i in range(len(seq)):
            if seq[i] in old_ss:
                old_ss = old_ss+seq[i]
            else:
                ss.append(old_ss)
                old_ss = seq[i]
            if i == len(seq)-1:
                ss.append(old_ss)
        for part in ss:
            if 'S' in part:
                sht_count = sht_count+1
            elif 'H' in part:
                hlx_count = hlx_count+1
        dataf.at[w, 'hlxCount'] = str(hlx_count)
        dataf.at[w, 'shtCount'] = str(sht_count)


check_seq(df)
df.to_csv(outfile, index=False)
