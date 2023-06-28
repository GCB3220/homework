import pandas as pd
import re
from pprint import pprint


df = pd.read_csv('C:/a/y-code/python1/file/pdb_info_to_gcb.csv', keep_default_na=False)
list_0 = df['classification'].tolist()
list_1 = df['het_short'].tolist()
list_2 = df['het_long'].tolist()
list_3 = df['title'].tolist()
list_4 = df['method'].tolist()
list_5 = df['pdb_id'].tolist()



back_list = []
origin_list = []
new_dict= {}
list_9 = []
special_list_1 = ['H', 'He', 'Li', 'Be', 'B', 'C', 'N', 'O', 'F', 'Ne', 'Na', 'Mg', 'Al', 'Si', 'P', 'S', 'Cl', 'Ar',
                  'K', 'Ca', 'Sc', 'Ti', 'V', 'Cr', 'Mn', 'Fe', 'Co', 'Ni', 'Cu', 'Zn', 'Ga', 'Ge', 'As', 'Se', 'Br',
                  'Kr', 'Rb', 'Sr', 'Y', 'Zr', 'Nb', 'Mo', 'Tc', 'Ru', 'Rh', 'Pd', 'Ag', 'Cd', 'In', 'Sn', 'Sb', 'Te',
                  'I', 'Xe', 'Cs', 'Ba', 'La', 'Ce', 'Pr', 'Nd', 'Pm', 'Sm', 'Eu', 'Gd', 'Tb', 'Dy', 'Ho', 'Er', 'Tm',
                  'Yb', 'Lu', 'Hf', 'Ta', 'W', 'Re', 'Os', 'Ir', 'Pt', 'Au', 'Hg', 'Tl', 'Pb', 'Bi', 'At', 'Rn', 'Po'
                  'Fr', 'Ra', 'Ac', 'Th', 'Pa', 'U', 'Np', 'Pu', 'Am', 'Cm', 'Bk', 'Cf', 'Es', 'Fm', 'Md', 'No', 'Lr',
                  'Rf', 'Db', 'Sg', 'Bh', 'Hs', 'Mt', 'Ds', 'Rg', 'Nh', 'Cn', 'Fl', 'Mc', 'Lv', 'Ts', 'Og']
special_list_1_2 = ['H', 'He', 'Li', 'Be', 'B', 'C', 'N', 'O', 'F', 'Ne', 'Na', 'Mg', 'Al', 'Si', 'P', 'S', 'Cl', 'Ar',
                  'K', 'Ca', 'Sc', 'Ti', 'V', 'Cr', 'Mn', 'Fe', 'Co', 'Ni', 'Cu', 'Zn', 'Ga', 'Ge', 'As', 'Se', 'Br',
                  'Kr', 'Rb', 'Sr', 'Y', 'Zr', 'Nb', 'Mo', 'Tc', 'Ru', 'Rh', 'Pd', 'Ag', 'Cd', 'In', 'Sn', 'Sb', 'Te',
                  'I', 'Xe', 'Cs', 'Ba', 'Hf', 'Ta', 'W', 'Re', 'Os', 'Ir', 'Pt', 'Au', 'Hg', 'Tl', 'Pb', 'Bi', 'At',
                  'Rn', 'Fr', 'Ra', 'Rf', 'Db', 'Sg', 'Bh', 'Hs', 'Mt', 'Ds', 'Rg', 'Cn', 'Fl', 'Mc', 'Ts', 'Og']
for w in list_5:
    if w == '7BZX':
        print(list_5.index(w))





for key in new_dict:
    new_dict[key] = list(set(new_dict[key]))


for key in new_dict:
    if key.capitalize() in special_list_1:
        list_9.append(key)


back_list = list(set(back_list))
origin_list = list(set(origin_list))
list_9 = list(set(list_9))
#pprint(list_0)
#pprint(back_list)
pprint(new_dict)
#pprint(origin_list)
#print(list_9)
#data = pd.DataFrame(new_dict)
#data.to_csv('C:/a/z-code/python1/file/b.csv')