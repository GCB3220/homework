import requests
import csv

def get_structure_info(pdb_id):
    url = f"https://data.rcsb.org/rest/v1/core/entry/{pdb_id}"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        title = data['struct']['title']
        return f"{title}"
    else:
        return f"Failed to retrieve information for PDB ID: {pdb_id}"

z = 12 # 文件名称
# Read the CSV file
csv_file_path = f'C:/a/y-code/python1/file/news/{z}.csv'  # Replace with the actual file path
output_csv_file_path = f'C:/a/y-code/python1/file/update_1/{z}.csv'  # Replace with the desired output file path

output_rows = []

with open(csv_file_path, 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        pdb_id = row['pdb_id']
        structure_info = get_structure_info(pdb_id)
        output_rows.append({'pdb_id': pdb_id, 'structure_info': structure_info})

# Write the data to a new CSV file
fieldnames = ['pdb_id', 'structure_info']
with open(output_csv_file_path, 'w', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(output_rows)

print("Data has been successfully written to the output CSV file.")
