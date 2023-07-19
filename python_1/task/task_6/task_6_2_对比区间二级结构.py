import pandas as pd
import re


# 读取/写入
read_file = 'C:/a/y-code/python1/task/task_6/seqInfo.csv'
data_file = 'C:/a/y-code/python1/task/task_6/pairInfo.csv'
out_file = 'C:/a/y-code/python1/task/task_6/out_pair.csv'
data_f = pd.read_csv(data_file)
read_f = pd.read_csv(read_file)


# 判断匹配出H/S
def pair_ss(df, rf):
    # 读取
    entity_q = df['entityQ']
    del_head_q = df['delHeadQ']
    del_tail_q = df['delTailQ']
    for i in range(len(entity_q)):
        # 如有: del项均为/或无值时,直接跳过
        if (del_head_q[i] == '/' and del_tail_q[i] == '/') or (type(del_head_q[i]) != str and del_tail_q[i] == '/') \
                or (type(del_tail_q[i]) != str and del_head_q[i] == '/') \
                or (type(del_tail_q[i]) != str and type(del_head_q[i]) != str):
            continue
        else:
            pdb = entity_q[i][0:4]  # 1CFC_1 -> 1CFC
            ss = rf.loc[rf['pdb'] == pdb, 'dst_ss'].to_string(index=False)  # 找到对应二级结构
            start = 0
            end = len(ss)
            if type(del_head_q[i]) == str and del_head_q[i] != '/':
                start = start + len(del_head_q[i])
            if type(del_tail_q[i]) == str and del_tail_q[i] != '/':
                end = end - len(del_tail_q[i])
            new_ss = ss[start:end]  # 匹配部分
            hlx_count = 0
            sht_count = 0
            old_ss = ''
            ss_list = []

            # 判断H/S
            # 提取ss按LHS分为不同项放入列表中, 如'LLLSSHHL'为['', 'LLL', 'SS', 'HH', 'L']
            # 检测每一项,如有S则+1sheet, 如有H则+1helix
            for z in range(len(new_ss)):
                if new_ss[z] in old_ss:
                    old_ss = old_ss + new_ss[z]
                else:
                    ss_list.append(old_ss)
                    old_ss = new_ss[z]
                if z == len(new_ss) - 1:
                    ss_list.append(old_ss)
            for part in ss_list:
                if 'S' in part:
                    sht_count = sht_count + 1
                elif 'H' in part:
                    hlx_count = hlx_count + 1

            # 填入数据, 如有0则省略项
            if hlx_count == 0:
                range_q_ss = str(sht_count) + 'β'
            elif sht_count == 0:
                range_q_ss = str(hlx_count) + 'α'
            else:
                range_q_ss = str(hlx_count) + 'α' + '+' + str(sht_count) + 'β'

            df.at[i, 'rangeQss'] = range_q_ss


pair_ss(data_f, read_f)
data_f.to_csv(out_file, index=False)