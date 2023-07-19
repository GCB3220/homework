import re
import pandas as pd

df = pd.read_csv('C:/a/y-code/python1/file/u.csv', keep_default_na=False)
s_list = ['CcdBVfi', 'GyrA14Vfi', 'DNA', 'RNA', 'III', 'I', 'II', 'Ca2+', 'NMR', 'Mg', 'Ni', 'EED', 'ALA', 'CBS',
          'GDP', 'FMN', 'KRAS', 'EGFR', 'Cl', 'RT', 'HIV', 'Fe', 'Cu', 'CED', 'NADPH', 'NADP', 'NAD', 'cNMP', 'ADPNP',
          'SDF', 'MRTX', 'FC', 'PD', 'MBP', 'VSV', 'IL', 'NTD', 'PA', 'PKCI', 'PFU', 'SYK', 'CoA', 'YJHP', 'LC', 'JPU',
          'EFI', 'CYS', 'SOS', 'SDS', 'APO', 'MFP', 'HIF', 'CFPS', 'YEIH', 'AMPK', 'CGTACG', 'EGFA', 'ENTH', 'MET',
          'ABC', 'HFRW', 'SFTI', 'NADH', 'TIBO']


def replace(column_name, list_1):
    # 建立字典
    dict_1 = {}
    for p in list_1:
        key = p.upper()
        dict_1[key] = p
    column = df[column_name]
    # 改变内容
    for i in range(len(column)):
        if column[i].upper() == column[i]:
            origin_list = re.findall(r'[^_\- \(\)/:]+', column[i])  # 提取字母数字存入list
            back_list = []
            for part in origin_list:
                index = origin_list.index(part)
                if re.search(r'[\d+*]', part) or len(part) == 1:
                    origin_list[index] = part
                else:
                    if part in dict_1.keys():
                        origin_list[index] = dict_1[part]
                    else:
                        origin_list[index] = part.lower()

            # 合并list并归入dataframe
            use_list = re.findall(r'[_\- \(\)/:]+', column[i])  # -_ ()/
            min_len = min(len(origin_list), len(use_list))
            if re.match(r'^[^_\- \(\)/:]', column[i]):  # 原内容字母数字开头
                if min_len == 0:  # 无标点空格则必为一个单词
                    back_list.extend(origin_list[0])
                else:
                    for a in range(min_len):
                        back_list.extend(origin_list[a])
                        back_list.extend(use_list[a])
                    if len(origin_list) > len(use_list):
                        back_list.extend(origin_list[min_len:])
                    elif len(origin_list) < len(use_list):
                        back_list.extend(use_list[min_len:])
            else:  # 原内容标点开头
                if min_len == 0:
                    back_list.extend(use_list[0])
                else:
                    for a in range(min_len):
                        back_list.extend(use_list[a])
                        back_list.extend(origin_list[a])
                    if len(origin_list) > len(use_list):
                        back_list.extend(origin_list[min_len:])
                    elif len(origin_list) < len(use_list):
                        back_list.extend(use_list[min_len:])
            replace_1 = ''.join(str(b) for b in back_list)
            df.at[i, column_name] = replace_1[0].upper()+replace_1[1:]

    return df

replace('structure_info', s_list)
df.to_csv('C:/a/y-code/python1/file/c.csv', index=False)
