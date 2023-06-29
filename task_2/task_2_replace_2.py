import requests
import csv
import time
import re

special_list_1 = ['H', 'Li', 'Be', 'B', 'C', 'N', 'O', 'F', 'Na', 'Mg', 'Al', 'Si', 'P', 'S', 'Cl', 'K', 'Ca',
                  'Sc', 'Ti', 'V', 'Cr', 'Mn', 'Fe', 'Co', 'Ni', 'Cu', 'Zn', 'Ga', 'Ge', 'As', 'Se', 'Br', 'Rb',
                  'Sr', 'Y', 'Zr', 'Nb', 'Mo', 'Tc', 'Ru', 'Rh', 'Pd', 'Ag', 'Cd', 'In', 'Sn', 'Sb', 'Te', 'I']# het_short 元素周期表,不包含后两行及稀有气体

def get_structure_info(pdb_id):
    url = f"https://data.rcsb.org/rest/v1/core/entry/{pdb_id}"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        title = data['struct']['title']
        if title.isupper():  # Check if the title is all uppercase
            primary_citation = data.get('rcsb_primary_citation', {})
            literature = primary_citation.get('title', None)
            if literature:
                list_title = title.split()
                list_liter = literature.split()
                up_dict = {}
                for word in list_liter:
                    key = word.upper()
                    if len(word) > 2 and word.capitalize() == word and not re.search(r'[0-9]', word):
                        # 防止literature每个单词首字母大写
                        word = word.lower()
                    up_dict[key] = word
                for part in list_title:
                    index = list_title.index(part)
                    if part in up_dict.keys():
                        list_title[index] = up_dict[part]
                    else:
                        if re.search(r'\([A-Z0-9]+\)', part) or re.search(r'[0-9]', part) or len(part) == 1\
                                or part.capitalize() in special_list_1:
                            # (ATCG)/其他缩写, CD13, 单个字母, 元素
                            list_title[index] = part
                        else:
                            list_title[index] = part.lower()
                replace_str = ' '.join(part for part in list_title)
                replace_str = replace_str[0].upper()+replace_str[1:]
                return replace_str
            else:
                return title
        else:
            return title
    else:
        return None

# Read the CSV file

for z in range(20, 203):
    csv_file_path = f'C:/a/y-code/python1/file/news/{z}.csv'  # Replace with the actual file path
    output_csv_file_path = f'C:/a/y-code/python1/file/update_1/{z}.csv'  # Replace with the desired output file path
    processed_pdb_ids = set()  # Set to store the PDB IDs already processed
    processed_count = 0  # Counter for the number of processed PDB IDs

    # Check if the output CSV file already exists and read the processed PDB IDs
    try:
        with open(output_csv_file_path, 'r') as output_file:
            reader = csv.reader(output_file)
            next(reader)  # Skip the header row
            for row in reader:
                pdb_id = row[0]
                processed_pdb_ids.add(pdb_id)
                processed_count += 1
    except FileNotFoundError:
        pass  # Ignore if the file doesn't exist

    with open(csv_file_path, 'r') as file:
        reader = csv.DictReader(file)
        with open(output_csv_file_path, 'a', newline='') as output_file:
            writer = csv.writer(output_file)
            if output_file.tell() == 0:  # Check if the output file is empty
                writer.writerow(['pdb_id', 'structure_info'])  # Write the header row
            for row in reader:
                pdb_id = row['pdb_id']
                if pdb_id in processed_pdb_ids:
                    continue  # Skip if the PDB ID has already been processed
                structure_info = get_structure_info(pdb_id)
                if structure_info is not None:
                    writer.writerow([pdb_id, structure_info])
                    processed_count += 1
                    print(f"Data for PDB ID {processed_count}:'{pdb_id}' has been successfully stored in the CSV file.")
                time.sleep(2)  # Sleep for 2 seconds between requests
    print(f"PDB IDs have been successfully processed and stored in the {z} CSV file.")
