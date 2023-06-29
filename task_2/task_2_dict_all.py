import pandas as pd
import re
from pprint import pprint
import openpyxl


df = pd.read_csv('C:/a/z-code/python1/file/pdb_info_to_gcb.csv')
list_0 = df['classification'].tolist()
list_1 = df['het_short'].tolist()
list_2 = df['het_long'].tolist()
list_3 = df['title'].tolist()
list_4 = df['method'].tolist()

class_list = list_0+list_1+list_2

# 去掉所以/()等符号
update_list = []
for element in list_0:
    element = str(element)
    update_list.extend(re.findall(r'[\w+]', element))

# 创建字典并排序
class_dict = {}
for word in update_list:
        if word in class_dict.keys():
            class_dict[word] = class_dict[word]+1
        else:
            class_dict[word] = 1
class_list_sort = sorted(class_dict.items(), key=lambda i: i[1], reverse=True)


# 大小写
word_list = [word for word, _ in class_list_sort]
new_list = []
new_list_1 = []
new_list_2 = []
for word in word_list:
 if len(word) > 5:
     new_list.append(word.capitalize())
 elif len(word) == 3:
     new_list_1.append(word)
 else:new_list_2.append(word)
pprint(new_list_1)