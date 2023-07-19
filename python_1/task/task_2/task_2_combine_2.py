import re
import os
import csv

path = 'C:/a/y-code/python1/file/update_1'
out_file = 'C:/a/y-code/python1/file/q.csv'

all_data = []
for filename in os.listdir(path):
    file_path = os.path.join(path, filename)
    with open(file_path, 'r') as file:
        csv_data = list(csv.reader(file))
        all_data.extend(csv_data)

with open(out_file, 'w', newline='') as outfile:
    writer = csv.writer(outfile)
    writer.writerows(all_data)