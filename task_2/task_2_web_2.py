import requests
import csv
import time

def get_structure_info(pdb_id):
    url = f"https://data.rcsb.org/rest/v1/core/entry/{pdb_id}"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        title = data['struct']['title']
        return title
    else:
        return None

# Read the CSV file
z = 0
for z in range(0, 203):
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
    z += 1