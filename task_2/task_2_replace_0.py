import pandas as pd
import re
from pprint import pprint


df = pd.read_csv('C:/a/y-code/python1/file/new.csv', keep_default_na=False)

# 以下均不完全
special_list_0 = ['AdoMet', 'GTPase', 'ATPase', 'AChBP', 'NADPH', 'CHNH2', 'FACIT', 'YJQ8WW',
                  'IgG2a', 'AChBP', 'RNase-2', 'GroEL', 'GroES', 'HSP24', 'HSP70',
                  'rCMTI', 'HK022', 'E.coli', 'CHOH', 'H2O2', 'tRNA', 'NADP', 'mRNA',
                  'RhoA', 'TATA', 'NADH', 'cAMP', 'AIDS', 'TonB', 'CcdB', 'CD36',
                  'RORG', 'RIFD', 'ThiJ', 'TrkA', 'IgG1', 'IMP4', 'CD36', 'RpoN',
                  'SUMO', 'CHNH', 'CHNH2', 'rRNA', 'PFPI', 'AFB1', 'cNMP', 'DNA', 'RNA',
                  'NAD', 'GTP', 'ATP', 'MHC', 'SH3', 'SH2', 'TBP', 'FMN', 'ADP',
                  'HIV', 'IgG', 'PO4', 'FAD', 'ANK', 'HLA', 'HNA', 'ERH', 'PQQ',
                  'BMP', 'PLP', 'TPP', 'RIM', 'XIV', 'GMP', 'CH2', 'NH2', 'RAR',
                  'TNF', 'PCB', 'IMP', 'ADE', 'III', 'CD1', 'LIM', 'SOS', 'AMP',
                  'CD8', 'CoA', 'MBT', 'HNF', 'CPG', 'DAN', 'RAN', 'RIM', 'SPP',
                  'VI', 'PX', 'PV', 'PI', 'CH', 'EF', 'NK', 'II', 'IX', 'NH', 'OH', ]# classification列的特殊案例
special_list_1 = ['H', 'Li', 'Be', 'B', 'C', 'N', 'O', 'F', 'Na', 'Mg', 'Al', 'Si', 'P', 'S', 'Cl', 'K', 'Ca',
                  'Sc', 'Ti', 'V', 'Cr', 'Mn', 'Fe', 'Co', 'Ni', 'Cu', 'Zn', 'Ga', 'Ge', 'As', 'Se', 'Br', 'Rb',
                  'Sr', 'Y', 'Zr', 'Nb', 'Mo', 'Tc', 'Ru', 'Rh', 'Pd', 'Ag', 'Cd', 'In', 'Sn', 'Sb', 'Te', 'I']# het_short 元素周期表,不包含后两行及稀有气体
special_list_2 = ['NADPH', 'IonFe', 'cGAMP', 'IonCu', 'prFMN', 'DMHBO', 'FdAMP', 'N3Phe',
                  'Fe4S4', 'DiCys', 'PtCl2', 'Fe8S9', 'CMBL4', 'SAFit', 'DMHBI', 'BetaR',
                  'NADP', 'TERT',  'DGDG', 'HEGA', 'OCTA', 'dTDP', 'ICOS', 'FeFe', 'GPAP',
                  'CuII', 'DPEA', 'DAHP', 'TetR', 'FDAM', 'NCPC', 'TAP2', 'mRNA', 'TRW3',
                  'PEG2', 'NBIC', 'MMPA', 'PCPA', 'CDEF', 'NTME', 'dATP', 'OD36', 'ONIC',
                  'DACH', 'HONH', 'CoBr', 'ProM', 'VIII', 'PoPo',  'III', 'CoA', 'OIC',
                  'AMP', 'ADP', 'SF4', 'TAP', 'XO4', 'FMN', 'LMN', 'PSI', 'GDP', 'TRP',
                  'CH2', 'STA', 'UDP', 'OMe',  'ATP', 'FAD', 'FeV', 'GTP', 'ClO', 'III',
                  'THF', 'OAC', 'K2N', 'K3S', 'CE1', 'MO8', 'TAK', 'CDP', 'YO3', 'RRR',
                  'DCM', 'CGP', 'PO2', 'N1E', 'CPI', 'PHF', 'CMP', 'KUT', 'OLN', 'NAD',
                  'C4A', 'AMG', 'UNC', 'GMP', 'PIK', 'TDP', 'JD1', 'AIK', 'YL6', 'WC5',
                  'HBA', 'aSR', 'bRS', 'CO4', 'Fe7', 'II', 'IX', 'NZ', 'VI', 'IV',
                  'FG', 'NG', 'OH', 'RP', 'HI', 'NH', 'HF', 'SP', 'AJ', 'PS', 'SV', 'CN',
                  'PG', 'NL', 'DA', 'WR', 'AD', 'DC', 'TR', 'aR', 'aS', 'bS', 'cS', 'bR',
                  'aH', 'HF', 'cR', 'cH', 'bH', 'aP', 'aE', 'RS', 'SR', 'HF', 'Cu', 'Fe']# het_long的特殊
special_list_3 = ['KDa', 'DNA', 'RNA', 'NADP', 'III', 'II', 'IV', 'ATP', 'NMR', 'GTP', 'ATPase', 'GTPase', '10E8v4',
                  'mm', 'IX', 'nm', 'ZnSO4', 'BcII', 'RnaseH', 'mmHg', 'ntRNA', 'IPM', '11H6H1', '12RNP2', '3BC176',
                  'ms', 'PEGB', 'XCHS', '1CGrx1', '1RAcPb', '1RAPL2', 'keV', '2AM20R', 'MbisP', '3BC315', '3CLpro',
                  '3FMTDZ', '3GTvNH', 'HTPE', '3rC34Y', '44SR3C', '4AB007', '5075UW', 'MPa', 'CCCGG', '5FIdoF',
                  'mdCTP', '5YF412', '5YF431', '665sXa', '6DHNAD', '6HMPPP', '73MuL9', '7VSDII', 'A0QQS4', 'A0QTM2',
                  'A0QBY3', ]# title!!!!!未完成
special_list_4 = ['EPR', 'NMR']# method


# 1:根据特殊案例建立字典. key=特殊案例全大写, value=正确写法
# 2:将指定列的单个内容,提取字母数字与字典key对比,有则填入value,无则一律首字母大写保留
# 2:如有数字开头,则数字后第一字母大写
# 3:将改变内容合并归入dataframe
def replace_0(column_name, list):
    # 建立字典
    dict = {}
    for p in list:
        key = p.upper()
        dict[key] = p
    column = df[column_name]
    # 改变内容
    for i in range(len(column)):
        origin_list = re.findall(r'\w+', column[i]) # 提取字母数字存入list
        back_list = []
        for part in origin_list:
            index = origin_list.index(part)
            part = part.upper() # 提取内容全大写方便与key比对
            if part in dict.keys():
                origin_list[index] = dict[part]
            else:
                origin_list[index] = part.capitalize()
            if re.match(r'^\d+', part): # 针对7AR等特殊项(应改为7aR 'het_long列')
                new = re.findall(r'[A-Z]+', part) # 提取字母
                new = ''.join(i for i in new)
                other = re.match(r'^\d+', part) # 提取数字
                if new in dict.keys():
                    origin_list[index] = other.group()+dict[new]
                else:
                    origin_list[index] = other.group()+new.capitalize()
        # 合并list并归入dataframe
        use_list = re.findall(r'\W+', column[i]) # 提取标点空格
        min_len = min(len(origin_list), len(use_list))
        if re.match(r'^\w', column[i]): # 原内容字母数字开头
            if min_len == 0: # 无标点空格则必为一个单词
                back_list.extend(origin_list[0])
            else:
                for a in range(min_len):
                    back_list.extend(origin_list[a])
                    back_list.extend(use_list[a])
                if len(origin_list) > len(use_list):
                    back_list.extend(origin_list[min_len:])
                elif len(origin_list) < len(use_list):
                    back_list.extend(use_list[min_len:])
        else: # 原内容标点开头
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
        df.at[i, column_name] = ''.join(str(b) for b in back_list)

    return df


# 对het_short列的偷懒办法
# 该列内容均为2-3个字母组成,大部分为缩写,所以只要根据元素周期表,元素首字母大写,其余全大写
def replace_1(column_name, list):
    # list为元素缩写
    dict = {}
    for p in list:
        key = p.upper()
        dict[key] = p

    column = df[column_name]
    for i in range(len(column)):
        origin_list = re.findall(r'\w+', column[i])
        back_list = []
        for part in origin_list:
            index = origin_list.index(part)
            part = part.upper()
            if part in dict.keys():# 字典中有的换,没得保留
                origin_list[index] = dict[part]
            # 此处针对Fe7, 6NA等元素+数字的项
            if re.search(r'\d+$', part):
                new = re.findall(r'[A-Z]+', part)
                new = ''.join(i for i in new)
                other = re.search(r'\d+$', part)
                if new in dict.keys():
                    origin_list[index] = dict[new] + other.group()
            if re.match(r'^\d+', part):
                new = re.findall(r'[A-Z]+', part)
                new = ''.join(i for i in new)
                other = re.match(r'^\d+', part)
                if new in dict.keys():
                    origin_list[index] = other.group() + dict[new]
                else:
                    origin_list[index] = other.group() + new.capitalize()

        use_list = re.findall(r'\W+', column[i])
        min_len = min(len(origin_list), len(use_list))
        if re.match(r'^\w', column[i]):
            if min_len == 0:
                back_list.extend(origin_list[0])
            else:
                for a in range(min_len):
                    back_list.extend(origin_list[a])
                    back_list.extend(use_list[a])
                if len(origin_list) > len(use_list):
                    back_list.extend(origin_list[min_len:])
                elif len(origin_list) < len(use_list):
                    back_list.extend(use_list[min_len:])
        else:
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
        df.at[i, column_name] = ''.join(str(b) for b in back_list)

    return df


# pdb_id
def replace_5(column_name):
    column = df[column_name]
    # 改变内容
    for i in range(len(column)):
        origin_list = re.findall(r'\w+', column[i]) # 提取字母数字存入list
        back_list = []
        for part in origin_list:
            index = origin_list.index(part)
            part = part.upper() # 提取内容全大写方便与key比对
            if part in dict.keys():
                origin_list[index] = dict[part]
            else:
                origin_list[index] = part.capitalize()
            if re.match(r'^\d+', part): # 针对7AR等特殊项(应改为7aR 'het_long列')
                new = re.findall(r'[A-Z]+', part) # 提取字母
                new = ''.join(i for i in new)
                other = re.match(r'^\d+', part) # 提取数字
                if new in dict.keys():
                    origin_list[index] = other.group()+dict[new]
                else:
                    origin_list[index] = other.group()+new.capitalize()
        # 合并list并归入dataframe
        use_list = re.findall(r'\W+', column[i]) # 提取标点空格
        min_len = min(len(origin_list), len(use_list))
        if re.match(r'^\w', column[i]): # 原内容字母数字开头
            if min_len == 0: # 无标点空格则必为一个单词
                back_list.extend(origin_list[0])
            else:
                for a in range(min_len):
                    back_list.extend(origin_list[a])
                    back_list.extend(use_list[a])
                if len(origin_list) > len(use_list):
                    back_list.extend(origin_list[min_len:])
                elif len(origin_list) < len(use_list):
                    back_list.extend(use_list[min_len:])
        else: # 原内容标点开头
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
        df.at[i, column_name] = ''.join(str(b) for b in back_list)

    return df




replace_0('classification', special_list_0)
replace_0('het_long', special_list_2)
replace_0('method', special_list_4)
replace_1('het_short', special_list_1)


df.to_csv('C:/a/y-code/python1/file/a.csv', index=False)