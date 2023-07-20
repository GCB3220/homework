import pandas as pd

read_file = 'C:/a/y-code/python2/task/task_6/seqInfo.csv'
data_file = 'C:/a/y-code/python2/task/task_6/pairInfo.csv'
out_file = 'C:/a/y-code/python2/task/task_6/out_pair.csv'
data_f = pd.read_csv(data_file)
read_f = pd.read_csv(read_file)


def ss_count(ss_seq: str):
    shorted_ss = ''
    for letter in ss_seq:
        if shorted_ss == '' or letter != shorted_ss[-1]:
            shorted_ss += letter
    hlx_count = shorted_ss.count('H')
    sht_count = shorted_ss.count('S')
    return [hlx_count, sht_count]

def format_ss(ssCount):
    hlx_count = ssCount[0]
    sht_count = ssCount[1]
    result = ''
    if hlx_count != 0:
        if hlx_count == 1:
            result += 'α'
        else:
            result += f'{hlx_count}α'
        if sht_count != 0:
            if result != '':
                result += '+'
            if sht_count == 1:
                result += 'β'
            else:
                result += f'{sht_count}β'
        if result == '':
            return '/'
        return result


def read_all(df, rf):
    # 读取
    entity_q = df['entityQ']
    del_head_q = df['delHeadQ']
    del_tail_q = df['delTailQ']
    entity_m = df['entityM']
    del_head_m = df['delHeadM']
    del_tail_m = df['delTailM']
    for i in range(len(entity_q)):
        pdb_1 = entity_q[i][0:4]  # 1CFC_1 -> 1CFC
        ss_1 = rf.loc[rf['pdb'] == pdb_1, 'dst_ss'].to_string(index=False)  # 找到对应二级结构
        start = 0
        end = -1
        if type(del_head_q[i]) == str and del_head_q[i] != '/':
            start += len(del_head_q[i])
        if type(del_tail_q[i]) == str and del_tail_q[i] != '/':
            end -= len(del_tail_q[i])
        new_ss_1 = ss_1[start:end]
        hlx_sht_1 = ss_count(new_ss_1)
        result_1 = format_ss(hlx_sht_1)

        pdb_2 = entity_m[i][0:4]  # 1CFC_1 -> 1CFC
        ss_2 = rf.loc[rf['pdb'] == pdb_2, 'dst_ss'].to_string(index=False)  # 找到对应二级结构
        start = 0
        end = -1
        if type(del_head_m[i]) == str and del_head_m[i] != '/':
            start += len(del_head_m[i])
        if type(del_tail_m[i]) == str and del_tail_m[i] != '/':
            end -= len(del_tail_m[i])
        new_ss_2 = ss_2[start:end]
        hlx_sht_2 = ss_count(new_ss_2)
        result_2 = format_ss(hlx_sht_2)

        df.at[i, 'rangeQss'] = result_1
        df.at[i, 'rangeMss'] = result_2

    return df

frame = read_all(data_f, read_f)
frame.to_csv(out_file, index=False)