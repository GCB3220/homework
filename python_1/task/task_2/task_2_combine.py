import csv

z = 0
for z in range(0, 38):
    file_1 = f'C:/a/y-code/python1/file/update_1/{z}.csv'
    file_2 = f'C:/a/y-code/python1/file/update_2/a.csv'
    with open(file_1, 'r') as read_file:
        read_1 = csv.DictReader(read_file)
        with open(file_2, 'a', newline='') as out_file:
            write_1 = csv.writer(out_file)
            if out_file.tell() == 0:
                heads = ['pdb_id', 'structure_info']
                write_1.writerow(heads)
            for row in read_1:
                body = [row['pdb_id'], row['structure_info']]
                write_1.writerow(body)
            z = z+1