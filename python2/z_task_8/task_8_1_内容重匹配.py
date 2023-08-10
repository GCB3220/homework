import pandas as pd
from Bio.Align import PairwiseAligner


read_file = r'C:/a/y-code/python1/z_task_8/0808newTask_1.csv'
read_file_1 = r'C:/a/y-code/python1/z_task_8/all_1.csv'
read_file_2 = r'C:/a/y-code/python1/z_task_8/初筛一部分的结果.csv'
out_file = r'C:/a/y-code/python1/z_task_8/out_2.csv'
data_f = pd.read_csv(read_file_2)


# 序列对比
def align_seq(seq_1, seq_2):
    aligner = PairwiseAligner(scoring='blastp')
    aligner.mode = 'global'
    if '+' not in (seq_1, seq_2):
        aligner.mismatch_score = -0.7
    else:
        aligner.mismatch_score = -0.5
    aligner.open_gap_score = -3
    aligner.extend_gap_score = -0.1
    aligner.target_end_gap_score = 0
    aligner.query_end_gap_score = 0
    alignments = aligner.align(seq_1, seq_2)[0]
    target = alignments[0]
    query = alignments[1]
    return target, query


# 修改一下, 防止seq1长度大于seq2
def match_sequence(seq1, seq2):
    head_count_1 = 0
    tail_count_1 = len(seq1)
    head_count_2 = 0
    tail_count_2 = len(seq2)
    # 去掉头尾--, 提取配对部分
    for char in seq1:
        if char == '-':
            head_count_1 += 1
        else:
            break
    for char in seq1[::-1]:
        if char == '-':
            tail_count_1 -= 1
        else:
            break

    for char in seq2:
        if char == '-':
            head_count_2 += 1
        else:
            break
    for char in seq2[::-1]:
        if char == '-':
            tail_count_2 -= 1
        else:
            break
    head_true = max(head_count_1, head_count_2)
    tail_true = min(tail_count_1, tail_count_2)
    if head_count_1 < head_count_2 or tail_count_1 > tail_count_2:
        check_l = 'yes'
    else:
        check_l = '/'

    return head_true, tail_true, check_l


def check_and_replace(seq1, seq2):
    new_seq_final = ''
    head_count, tail_count, check_len = match_sequence(seq1, seq2)
    new_seq1 = seq1[head_count:tail_count]
    new_seq2 = seq2[head_count:tail_count]
    detect = '/'
    for am_index, (am1, am2) in enumerate(zip(new_seq1, new_seq2)):
        if am1 == am2:
            new_seq_final += am1
        else:
            if am1 == '-':  # 丢失部分补全
                new_seq_final += am2
            elif am1 == 'X' and am2 != '-':  # 'X'替换
                new_seq_final += am2
            else:
                new_seq_final += am1
        if 'X' not in (am1, am2) and '-' not in (am1, am2) and am1 != am2:
            detect = 'yes'

    return new_seq_final, check_len, detect


new_data = {'entity': [],
            'new_seq': [],
            '变化了(X)': [],
            'seqFull更短': [],
            '存在其他不同': []}

low_quality = data_f['lowQuality']
for index, judge in enumerate(low_quality):
    entity = data_f['entity'][index]
    if judge:
        new_seq_3 = 'low_quality'
        check = '/'
        check_len_1 = '/'
        detect_1 = '/'
    else:
        seqOld_2 = data_f['sequence'][index]
        seqFull_2 = data_f['sequenceFull'][index]
        new_seq_2, new_seqFull_2 = align_seq(seqOld_2, seqFull_2)
        new_seq_3, check_len_1, detect_1 = check_and_replace(new_seq_2, new_seqFull_2)
        # 判断是否有变化
        if 'X' in seqOld_2:
            check = 'yes'
        else:
            check = '/'

    new_data['entity'].append(entity)
    new_data['new_seq'].append(new_seq_3)
    new_data['变化了(X)'].append(check)
    new_data['seqFull更短'].append(check_len_1)
    new_data['存在其他不同'].append(detect_1)


nf = pd.DataFrame(new_data)
nf.to_csv(out_file, index=False)