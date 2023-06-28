import re


#compare
start = 3
end = 56
del_m_list = ["-1-2 GDEK", "57-59 RRS"]
ins_q_list = ['2 GDEK', '56 RRS']


def replace(list):
    #check head
    match_head = re.search(r'\d-(.+)\s', list[0])#\s:space
    if match_head:
        if int(match_head.group(1))+1 == start:
            list[0] = re.sub(r'.+\d', "head", list[0])
    else: list[0] = re.sub(r'.+\d', "head", list[0])#simple number
    #check tail
    match_tail = re.search(r'(.\d+)-', list[-1])
    if match_tail:
        if int(match_tail.group(1))-1 == end:
            list[-1] = re.sub(r'.+\d', "tail", list[-1])
    else:
        list[-1] = re.sub(r'.+\d', "tail", list[-1])

    return list


replace(ins_q_list)
