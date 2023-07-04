from pprint import pprint
old_dict = {'1': 'M', '9': 'L', '10': 'K', '11': 'S', '12': 'L', '13': 'P',
            '14': 'G', '15': 'M', '49': 'M', '80': 'S', '171': 'M', '197': 'M',
            '202': 'M', '294': 'M', '316': 'E', '317': 'S', '318': 'F', '319': 'K',
            '320': 'S', '321': 'R', '330': 'M', '337': 'S', '338': 'C', '339': 'Y',
            '340': 'E', '341': 'A', '342': 'P', '343': 'E', '344': 'M', '360': 'E',
            '361': 'N', '362': 'H', '379': 'A', '380': 'D', '381': 'G'}

key_list = []
new_dict = {}

for key in old_dict:
    key_list.append(key)

i = 0
a = 1
while i < len(key_list):
    new_value = old_dict[key_list[i]]
    new_key = key_list[i]
    if i == len(key_list)-1:
        new_dict[new_key] = new_value
        i = i+1
    else:
        if int(key_list[i]) == int(key_list[i + 1]) - 1:
            a = 1
            while a + i < len(key_list):
                if int(key_list[i]) == int(key_list[i + a]) - a:
                    value_1 = old_dict[key_list[i + a]]
                    new_key = f'{key_list[i]}-{key_list[i + a]}'
                    new_value = new_value + value_1
                    a = a + 1
                else:
                    break
            new_dict[new_key] = new_value
            i = i + a
        else:
            new_dict[new_key] = new_value
            i = i + 1

print(new_dict)