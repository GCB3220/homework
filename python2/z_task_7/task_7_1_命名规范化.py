from Bio.Align import PairwiseAligner
import pandas as pd

read_file = 'C:/a/y-code/python1/z_task_6/seqInfo.csv'
data_file = 'C:/a/y-code/python1/z_task_7/all.csv'
out_file = 'C:/a/y-code/python1/z_task_7/all_1.csv'
final_file = 'C:/a/y-code/python1/z_task_7/all_2.csv'
dict_file = 'C:/a/y-code/python1/z_task_7/Amino Acid.xlsx'
test_file = 'C:/a/y-code/python1/z_task_7/all_3.csv'
# data_f = pd.read_csv(data_file)
# df = data_f.head(1000)
# read_f = pd.read_csv(read_file)
# dict_f = pd.read_excel(dict_file)


# 将蛋白序列, 蛋白起始终止点位放在一起
def put_data_together(data1, data2):
    new_data = data1[['pair', 'pdbQ', 'pdbM']].copy()
    col_q = []
    col_m = []
    start_q = []
    end_q = []
    start_m = []
    end_m = []
    for index, pdb_q in enumerate(data1['pdbQ']):
        q = data2.loc[data2['pdb'] == pdb_q, 'dst_seq'].tolist()
        m = data2.loc[data2['pdb'] == data1['pdbM'][index], 'dst_seq'].tolist()
        col_m.append(m[0])
        col_q.append(q[0])
        s_q = data2.loc[data2['pdb'] == pdb_q, 'startPoint'].tolist()
        e_q = data2.loc[data2['pdb'] == pdb_q, 'endPoint'].tolist()
        start_q.append(s_q[0])
        end_q.append(e_q[0])
        s_m = data2.loc[data2['pdb'] == data1['pdbM'][index], 'startPoint'].tolist()
        e_m = data2.loc[data2['pdb'] == data1['pdbM'][index], 'endPoint'].tolist()
        start_m.append(s_m[0])
        end_m.append(e_m[0])
    new_data['seqQ'] = col_q
    new_data['seqM'] = col_m
    new_data['startQ'] = start_q
    new_data['endQ'] = end_q
    new_data['starM'] = start_m
    new_data['endM'] = end_m

    return new_data


# rf = put_data_together(df, read_f)
# rf.to_csv(out_file, index=False)
rf = pd.read_csv(out_file)


# 氨基酸字母简称字典, 如G:Gly
def amino_pair(data):
    am_dict = {}
    keys = data['SHORT']
    values = data['EN_SHORT']
    for index, key in enumerate(keys):
        am_dict[key] = values[index]
    return am_dict


# 提取个蛋白的起始/终止位点,做成字典 pdb:[startpoint, endpoint]
def start_p(data):
    s_e = {}
    start = data['startPoint']
    end = data['endPoint']
    pdb_id = data['pdb']
    for index, pdb in enumerate(pdb_id):
        value = [start[index], end[index]]
        s_e[pdb] = value
    return s_e


# amino_dict = amino_pair(dict_f)
amino_dict = {'G': 'Gly', 'A': 'Ala', 'V': 'Val', 'L': 'Leu', 'I': 'Ile', 'P': 'Pro', 'F': 'Phe', 'Y': 'Tyr',
              'W': 'Trp', 'S': 'Ser', 'T': 'Thr', 'C': 'Cys', 'M': 'Met', 'N': 'Asn', 'Q': 'Gln', 'D': 'Asp',
              'E': 'Glu', 'K': 'Lys', 'R': 'Arg', 'H': 'His', 'U': 'Sec', 'O': 'Pyl', 'B': 'Asx', 'Z': 'Glx',
              'X': 'Xaa', 'J': 'Xle'}


# 将data放入一个文件后就不用了
# s_e_point = start_p(read_f)
# s_e_point = {}


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


# 取得两个链后, 取各氨基酸位置, 将其分为三组(三个列表): del/删除, ins/插入, rep/替换
def combine_tar(tar_1, que_1):
    del_1 = []
    ins_1 = []
    rep_1 = []
    for index, (am_1, am_2) in enumerate(zip(tar_1, que_1)):
        if '+' in (am_1, am_2) and '-' not in (am_1, am_2):
            continue
        elif am_1 == am_2:
            continue
        else:
            if am_1 == '-':
                ins_1.append(index)
            elif am_2 == '-':
                del_1.append(index)
            else:
                rep_1.append(index)
    return del_1, ins_1, rep_1


# 此函数会将列表中个位置分类, 若出现连续这归为group, 其余为single
# 比如: [1, 3, 5, 6, 7, 8, 12, 13]被分为single:[1, 3], group:[[5, 8], [12, 13]]
# 我计划将del/rep/ins三组合并, 然后执行此函数, 之后遍历rep
# 如果rep项在single中, 则为substitution, 如果在group中, 则为deletion-insertion
# 这样之后再依据del和ins两个列表分配single和group余下项
def combine_value(in_lis: list):
    index_1 = 0
    jump = 1
    group_1 = []
    single_1 = []
    new_val = []
    while index_1 < len(in_lis) - 1:
        if in_lis[index_1] + 1 != in_lis[index_1 + 1]:  # 不连续
            single_1.append(in_lis[index_1])
            index_1 += 1
        else:
            while index_1 + jump <= len(in_lis) - 1:
                if in_lis[index_1] + jump == in_lis[index_1 + jump]:
                    new_val = [in_lis[index_1], in_lis[index_1 + jump]]
                    jump += 1  # 如果a与a+1项差1, 那么再检测a与a+2是否差2, 之后类推
                else:
                    break
            group_1.append(new_val)
            index_1 += jump
            jump = 1
    return group_1, single_1


# 先分配deletion-insertion和substitution
# input:rep, group, single
# rep中的项, 如果出现在single中, 则为substitution, 反之则为del-ins
# del/rep/ins三组合并得到single+group, 所以每匹配一项就删一项
# rep优先, 因为group中del+rep是del-ins, ins+rep也是del-ins
def delins_sort(rep_2, group_2, single_2):
    sub_1 = []
    delins_1 = []
    for part in rep_2:
        if part in single_2 and part not in sub_1:
            sub_1.append(part)
        else:
            for g in group_2:
                if g[0] <= part <= g[1] and g not in delins_1:  # 确定区间
                    delins_1.append(g)
    return sub_1, delins_1


# 分配del和ins,
def sort_name(d_or_i, sub_2, delins_2):
    result = []
    no_sub = []
    for am in d_or_i:
        if am in sub_2:
            result.append(am)
        else:
            for g in delins_2:
                if g[0] <= am <= g[1]:  # 确定区间
                    result.append(am)
    for iterm in d_or_i:
        if iterm not in result:
            no_sub.append(iterm)
    no_sub.sort()
    new_g, new_s = combine_value(no_sub)
    new_lis = new_s + new_g
    return new_lis


# 判断ins中是否有extension/duplication ?????????????
def ext_check(ins_4, tar_4):
    ext_4 = []
    ins_4_1 = []
    end = len(tar_4)-1
    for point in ins_4:
        if type(point) == int:
            if point == 0 or point == end:
                ext_4.append(point)
            else:
                ins_4_1.append(point)
        else:
            if point[0] == 0 or point[1] == end:
                ext_4.append(point)
            else:
                ins_4_1.append(point)

    return ext_4, ins_4_1


def dup_check(ext_5, tar_5, que_5):
    seq = '/'
    dup_6 = []
    ext_6 = []
    for point in ext_5:
        if type(point) == int and point != 0:
            seq = que_5[point]
        elif type(point) == list and point[0] != 0:
            seq = que_5[point[0]:point[1] + 1]
        if seq in tar_5:
            dup_6.append(point)
        else:
            ext_6.append(point)

    return ext_6, dup_6


# 标准命名
# del, input:del列表, sequence, sequence的start, 对应索引
def del_name(del_5, seq_5, start, tr_ind):
    name_5 = ''
    for position in del_5:
        if type(position) == int:
            am_5 = amino_dict[seq_5[position]]
            true_po = tr_ind[position] + start
            name_5 += f'{am_5}{true_po}del; '
        else:
            am_5_1 = amino_dict[seq_5[position[0]]]
            am_5_2 = amino_dict[seq_5[position[1]]]
            true_po_1 = tr_ind[position[0]] + start
            true_po_2 = tr_ind[position[1]] + start
            name_5 += f'{am_5_1}{true_po_1}_{am_5_2}{true_po_2}del; '
    if name_5 == '':
        name_5 = '/'

    return name_5


# ins, input:ins列表,sequence, 配对sequence, sequence的start 对应索引 ?
def ins_name(ins_5, seq_5, seq_6, start, tr_ind):
    name_5 = ''
    for position in ins_5:
        if type(position) == int:
            am_6 = amino_dict[seq_6[position]]
            am_5_1 = amino_dict[seq_5[position - 1]]
            am_5_2 = amino_dict[seq_5[position + 1]]
            true_po_1 = tr_ind[position-1] + start
            true_po_2 = tr_ind[position+1] + start
            name_5 += f'{am_5_1}{true_po_1}_{am_5_2}{true_po_2}ins{am_6}; '
        elif type(position) == list:
            am = seq_6[position[0]:position[1] + 1]
            am_6 = ''
            for a in am:
                am_6 += amino_dict[a]
            am_5_1 = amino_dict[seq_5[position[0] - 1]]
            am_5_2 = amino_dict[seq_5[position[1] + 1]]
            true_po_1 = tr_ind[position[0]-1] + start
            true_po_2 = tr_ind[position[1]+1] + start
            name_5 += f'{am_5_1}{true_po_1}_{am_5_2}{true_po_2}ins{am_6}; '
        else:
            continue
    if name_5 == '':
        name_5 = '/'

    return name_5


# sub, input:sub列表, sequence, 配对sequence, sequence的start
def sub_name(sub_5, seq_5, seq_6, start, tr_in):
    name_5 = ''
    for position in sub_5:
        am_5 = amino_dict[seq_5[position]]
        am_6 = amino_dict[seq_6[position]]
        true_po = tr_in[position] + start
        name_5 += f'{am_5}{true_po}{am_6}; '
    if name_5 == '':
        name_5 = '/'

    return name_5


# del-ins, input:del_ins列表, sequence, 配对sequence, sequence的start
def d_i_name(d_i_5, seq_5, seq_6, start, tr_ind):
    name_5 = ''
    for position in d_i_5:
        seq_old_1 = seq_5[position[0]:position[1] + 1]
        new_seq_1 = []
        seq_old_2 = seq_6[position[0]:position[1] + 1]
        new_seq_2 = seq_old_2.replace('-', '')
        for index, iterm in enumerate(seq_old_1):
            if iterm == '-':
                continue
            else:
                new_seq_1.append([index, iterm])
        am_6 = ''
        for am in new_seq_2:
            am_6 += amino_dict[am]
        if len(new_seq_1) == 1:
            am_5 = amino_dict[new_seq_1[0][1]]
            true_po = tr_ind[new_seq_1[0][0] + position[0]] + start
            name_5 += f'{am_5}{true_po}delins{am_6}; '
        else:
            am_5_1 = amino_dict[new_seq_1[0][1]]
            am_5_2 = amino_dict[new_seq_1[-1][1]]
            true_po_1 = tr_ind[new_seq_1[0][0] + position[0]] + start
            true_po_2 = tr_ind[new_seq_1[-1][0] + position[0]] + start
            name_5 += f'{am_5_1}{true_po_1}_{am_5_2}{true_po_2}delins{am_6}; '
    if name_5 == '':
        name_5 = '/'

    return name_5


# dup命名
def dup_name(dup_5, seq_5, seq_6, start, tr_ind):
    name_5 = '/'
    if dup_5:
        dup_need = dup_5[0]
        if type(dup_need) == list:
            seq_check = seq_6[dup_need[0]:dup_need[1] + 1]
            am_5_1 = amino_dict[seq_check[0]]
            am_5_2 = amino_dict[seq_check[-1]]
            index_1 = seq_5.find(seq_check)
            true_po_1 = tr_ind[index_1] + start
            index_2 = index_1 + len(seq_check) - 1
            true_po_2 = tr_ind[index_2] + start
            name_5 = f'{am_5_1}{true_po_1}_{am_5_2}{true_po_2}dup'
        elif type(dup_need) == int:
            seq_check = seq_6[dup_5[0]]
            am_5 = amino_dict[seq_check]
            index_1 = seq_5.find(seq_check)
            ture_po = tr_ind[index_1] + start
            name_5 = f'{am_5}{ture_po}dup'

    return name_5


def true_index(seq_align):
    index_dict = {}
    q = 0
    for index, am in enumerate(seq_align):
        if am == '-':
            continue
        else:
            index_dict[index] = q
            q += 1

    return index_dict


def read_and_over_q(seq_q, seq_m, start):
    if '+' in seq_q or '+' in seq_m:
        delins_name_1 = '+error'
        sub_name_1 = '+error'
        del_name_1 = '+error'
        ins_name_1 = '+error'
        ext_q = '+error'
        dup_name_1 = '+error'
    else:
        # 对比
        tar_q, que_m = align_seq(seq_q, seq_m)
        # 索引
        index_q = true_index(tar_q)
        # 分组
        del_q, ins_q, rep_q = combine_tar(tar_q, que_m)
        all_list = del_q + ins_q + rep_q
        all_list.sort()
        group_q, single_q = combine_value(all_list)
        # 得出sub, delins
        sub_q, del_ins_q = delins_sort(rep_q, group_q, single_q)
        # 得出ins
        ins_new = sort_name(ins_q, sub_q, del_ins_q)
        # ext/dup
        ext_q, ins_new = ext_check(ins_new, tar_q)
        ext_q, dup_q = dup_check(ext_q, tar_q, que_m)
        # 得出del
        del_new = sort_name(del_q, sub_q, del_ins_q)
        # delins命名
        delins_name_1 = d_i_name(del_ins_q, tar_q, que_m, start, index_q)
        # sub命名
        sub_name_1 = sub_name(sub_q, tar_q, que_m, start, index_q)
        # ins命名
        ins_name_1 = ins_name(ins_new, tar_q, que_m, start, index_q)
        # ext命名
        # dup命名
        dup_name_1 = dup_name(dup_q, tar_q, que_m, start, index_q)
        # del命名
        del_name_1 = del_name(del_new, tar_q, start, index_q)

    return delins_name_1, sub_name_1, ins_name_1, ext_q, dup_name_1, del_name_1


data_n = {'pair(Q/P)': [],
          'delinsQ': [],
          'subQ': [],
          'delQ': [],
          'insQ': [],
          'extQ': [],
          'dupQ': [],
          'delinsM': [],
          'subM': [],
          'delM': [],
          'insM': [],
          'extM': [],
          'dupM': []}
for i, seqM in enumerate(rf['seqM']):
    seqQ = rf['seqQ'][i]
    start_1 = rf['startQ'][i]
    start_2 = rf['startM'][i]
    delinsQ, subQ, insQ, extQ, dupQ, delQ = read_and_over_q(seqQ, seqM, start_1)
    delinsM, subM, insM, extM, dupM, delM = read_and_over_q(seqM, seqQ, start_2)
    data_n['pair(Q/P)'].append(rf['pair'][i])
    data_n['delinsQ'].append(delinsQ)
    data_n['subQ'].append(subQ)
    data_n['delQ'].append(delQ)
    data_n['insQ'].append(insQ)
    data_n['extQ'].append(extQ)
    data_n['dupQ'].append(dupQ)
    data_n['delinsM'].append(delinsM)
    data_n['subM'].append(subM)
    data_n['delM'].append(delM)
    data_n['insM'].append(insM)
    data_n['extM'].append(extM)
    data_n['dupM'].append(dupM)

df = pd.DataFrame(data_n)
df.to_csv(final_file, index=False)
