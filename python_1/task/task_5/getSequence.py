import pickle
import pymol as py
import pandas as pd


def get_src_dict(obj) -> dict:
    """

    param obj: here is the object that cmd.load(filePath,obj)
    :return: a dict that contains resn, resi, ss & one-letter sequence(as list format)
    example:
    resn ['ARG', 'PRO', 'ARG', 'THR', 'ALA']
    resi ['3', '4', '5', '6', '7']
    ss ['L', 'L', 'L', 'L', 'L']
    letters ['R', 'P', 'R', 'T', 'A']
    """
    py.stored.resn = []
    py.stored.resi = []
    py.stored.ss = []
    py.stored.letters = []
    py.cmd.iterate("%s and n. ca" % obj, "stored.resi.append((resi))")
    py.cmd.iterate("%s and n. ca" % obj, "stored.resn.append((resn))")
    py.cmd.iterate("%s and n. ca" % obj, "stored.ss.append((ss))")
    py.cmd.iterate("%s and n. ca" % obj, "stored.letters.append((oneletter))")
    for i in range(len(py.stored.resi)):
        if py.stored.ss[i] == '':
            py.stored.ss[i] = 'L'
    mydf = pd.DataFrame({
        'resn': py.stored.resn,
        'resi': py.stored.resi,
        'ss': py.stored.ss,
        'letters': py.stored.letters

    })
    mydf.drop_duplicates(inplace=True, ignore_index=True)
    mydf['resi'] = mydf['resi']
    myDict = {
        'resn': list(mydf['resn']),
        'resi': list(mydf['resi']),
        'ss': ''.join(list(mydf['ss'])),
        'letters': ''.join(list(mydf['letters']))

    }
    return myDict


def get_dst_dict(src) -> dict:
    """
    这里由于部分蛋白的结构文件中缺少对应位点的氨基酸，所以进行此填充
    :param src: 这里是处理之前得到的字典，因此字典的内容为resn, resi, ss 以及 one-letter sequence
    :return: 填充完成之后的字典
    """
    resn = []
    resi = []
    ss = []
    letters = []
    length_src = len(src['resi'])
    # length_dst = int(mydict['resi'][-1]) - int(mydict['resi'][0])
    for index in range(length_src - 1):
        try:
            this = int(src['resi'][index])
            next_ = int(src['resi'][index + 1])
            if next_ - this == 1:
                resn.append(src['resn'][index])
                resi.append(src['resi'][index])
                ss.append(src['ss'][index])
                letters.append(src['letters'][index])
            else:
                while next_ - this != 1:
                    resn.append('MIS')
                    resi.append(this)
                    ss.append('L')
                    letters.append('+')
                    this += 1
        except:
            resn.append(src['resn'][index])
            resi.append(src['resi'][index])
            ss.append(src['ss'][index])
            letters.append(src['letters'][index])
    resn.append(src['resn'][length_src - 1])
    resi.append(src['resi'][length_src - 1])
    ss.append(src['ss'][length_src - 1])
    letters.append(src['letters'][length_src - 1])
    return {
        'resn': resn,
        'resi': resi,
        'ss': ''.join(ss),
        'letters': ''.join(letters)
    }
