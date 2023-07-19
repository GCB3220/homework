import re
import pandas as pd
from pprint import pprint


s_list = ['CcdBVfi', 'GyrA14Vfi', 'DNA', 'RNA', 'III', 'I', 'II', 'Ca2+', 'NMR', 'Mg', 'NI(II)', 'EED', 'ALA', 'CBS',
          'GDP', 'FMN', 'KRAS', 'EGFR', ]

output_file_path = 'C:/a/y-code/python1/file/q.csv'
with open(output_file_path, 'r') as out_file:
    reader = pd.read_csv(out_file)
    column = reader.iloc[:, 1]
    new_list = []
    q = 0
    for i in column:
        if i.upper() == i:
            new_list.append(i)
        if re.search(r'[0-9]-[A-Z]+', i):
            z = re.search(r'[0-9]-[A-Z]+', i).group()
        q = q+1

# */number/3/
#new_list = list(set(new_list))
pprint(new_list)
