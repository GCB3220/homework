class SequenceInfo:
    def __init__(self, sequence: str, ss_info: str, resn: list, points: list):
        """

        :param sequence: 'RPRTAFSSEQLARLKREFNENRYLTERRRQQLSSELGLNEAQIKIWFQNKRAKI'
        :param ss_info: 'LLLLLLLHHHHHHHHHHHHHLLLLLHHHHHHHHHHLLLLHHHHHHHHHHHHHHH'
        """
        self.seq = Seq(sequence)
        self.ss_seq = ss_info
        self.length = len(self.seq)
        self.start_point = points[0]
        self.end_point = points[1]
        self.resn = resn

    def get_style(self) -> list:
        style_info = []
        for _ in range(self.length):
            style_class = 'ew '
            char = self.seq[_]
            if char != '+':
                title = f'{self.start_point + _}, {self.resn[_]}'
                if self.ss_seq[_] == 'H':
                    style_class += 'hlx '
                elif self.ss_seq[_] == 'S':
                    style_class += 'sht '
            else:
                title = '-'
            style_info.append(
                {
                    'char': char,
                    'class': style_class.strip(),
                    'title': title
                }
            )
        return style_info


class Alignment:
    def __init__(self, query: SequenceInfo, match: SequenceInfo):
        self.query = query
        self.match = match
        self.spq = query.start_point
        self.epq = query.end_point
        self.spm = match.start_point
        self.epm = match.end_point
        self.alignment = self.get_alignment()
        # self.region = self.match_region()
        self.align_q = self.alignment[0]
        self.align_m = self.alignment[1]

    def get_alignment(self):
        aligner = PairwiseAligner(scoring='blastp')
        aligner.mode = 'global'

        aligner.match_score = 2
        if '+' not in self.query.seq:
            aligner.mismatch_score = -0.7
        else:
            aligner.mismatch_score = -0.5
        aligner.open_gap_score = -3
        aligner.extend_gap_score = -0.1
        aligner.target_end_gap_score = 0
        aligner.query_end_gap_score = 0
        alignment = aligner.align(self.query.seq, self.match.seq)[0]
        return alignment

    # def match_region(self):
    #     alignment = self.get_alignment()
    #     align_q = alignment[0]
    #     align_m = alignment[1]
    #
    #     def get_point(seq) -> list:
    #         point = []
    #         for i in seq:
    #             if i != '-':
    #                 point.append(seq.find(i))
    #                 break
    #         for i in reversed(seq):
    #             if i != '-':
    #                 point.append(seq.rfind(i))
    #                 break
    #         return point
    #
    #     point_q = get_point(align_q)
    #     point_m = get_point(align_m)
    #     _ = sorted(point_q + point_m)[1:3]
    #     return _

    def get_align_style(self):
        query_style = self.query.get_style()
        match_style = self.match.get_style()
        query_align_seq = self.alignment[0]
        match_align_seq = self.alignment[1]
        align_len = len(query_align_seq)
        count_q, count_m = 0, 0
        style_query, style_match = [], []
        for _ in range(align_len):
            char_q = query_align_seq[_]
            char_m = match_align_seq[_]
            if char_q != '-':
                style_q = query_style[count_q]
                if char_q == '+':
                    style_q['char'] = '-'
                    style_q['title'] = '/'
                if char_q != char_m:
                    style_q['class'] += ' mut'
                count_q += 1
            else:
                style_q = {
                    'char': '-',
                    'class': 'ew',
                    'title': '/'
                }
            if char_m != '-':
                style_m = match_style[count_m]
                if char_m == '+':
                    style_m['char'] = '-'
                    style_m['title'] = '/'
                if char_q != char_m:
                    style_m['class'] += ' mut'
                count_m += 1
            else:
                style_m = {
                    'char': '-',
                    'class': 'ew',
                    'title': '/'
                }
            style_query.append(style_q)
            style_match.append(style_m)
        style = {
            'style_query': style_query,
            'style_match': style_match,
        }
        return style

    def get_mutation(self) -> dict:
        del_q, ins_q, rep_q = [], [], []
        del_m, ins_m, rep_m = [], [], []
        position_q = self.spq
        # end_q = self.query.end_point
        position_m = self.spm
        # end_q = self.match.end_point
        align_len = len(self.align_q)
        for index in range(align_len):
            q = self.align_q[index]
            m = self.align_m[index]
            # if q != m:
            #     if q == '-' or q == '+':
            #         ins_q.append(f'{position_q} {m}')
            #         del_m.append(f'{position_m} {m}')
            #         position_m += 1
            #     elif m == '-' or m == '+':
            #         ins_m.append(f'{position_m} {q}')
            #         del_q.append(f'{position_m} {q}')
            #         position_q += 1
            #     else:
            #         rep_q.append(f'{position_q} {q}->{m}')
            #         rep_m.append(f'{position_m} {m}->{q}')
            #         position_q += 1
            #         position_m += 1
            # elif q != '+':
            #     position_q += 1
            #     position_m += 1

            # 这里我就不管结构中缺失的内容了，默认为对齐
            if q != m and q != '+' and m != '+':
                if q == '-':
                    ins_q.append(f'{position_q} {m}')
                    del_m.append(f'{position_m} {m}')
                    # print(position_m,end='\t')
                    position_m += 1
                    # print(position_m)
                elif m == '-':
                    ins_m.append(f'{position_m} {q}')
                    del_q.append(f'{position_q} {q}')
                    # print(position_q,end='\t')
                    position_q += 1
                    # print(position_q)
                else:
                    rep_q.append(f'{position_q} {q}->{m}')
                    rep_m.append(f'{position_m} {m}->{q}')
                    position_q += 1
                    position_m += 1
            else:
                position_q += 1
                position_m += 1
        mut = {
            'del_q': format_del(del_q, self.spq, self.epq),
            'ins_q': format_ins(ins_q, self.spq, self.epq),
            'rep_q': '; '.join(rep_q) if rep_q != [] else '/',
            'del_m': format_del(del_m, self.spm, self.epm),
            'ins_m': format_ins(ins_m, self.spm, self.epm),
            'rep_m': '; '.join(rep_m) if rep_m != [] else '/'
        }
        return mut


def startpoint(position: str) -> int:
    dash_count = position.count('-')
    chars = position.split('-')
    if dash_count == 1:
        sp = chars[0]
    else:
        if position[-3:] == '--1':
            if dash_count == 2:
                sp = chars[0]
            else:
                sp = f'-{chars[1]}'
        else:
            sp = f'-{chars[1]}'
    try:
        return int(sp)
    except:
        return -99


def endpoint(position) -> int:
    dash_count = position.count('-')
    chars = position.split('-')
    if dash_count == 1:
        ep = chars[1]
    elif dash_count == 2:
        if '--' in position:
            ep = chars[0]
        else:
            ep = chars[2]
    else:
        ep = f'-{chars[3]}'
    try:
        return int(ep)
    except:
        return -99


def format_del(__: list, sp: int, ep: int):
    del_dict = {}
    if len(__) >= 1:
        if '/' in __:
            __.remove('/')
        for _ in __:
            info = _.split()
            if info[0] in del_dict.keys():
                del_dict[info[0]] += info[1]
            else:
                del_dict[info[0]] = info[1]
        del_dict = optimize_dict(del_dict)
        hhh = []
        for kd, vd in del_dict.items():
            if '-' in kd:
                if startpoint(kd) == sp:
                    hhh.append(f'HeadDel {vd}')
                elif endpoint(kd) >= ep:
                    hhh.append(f'TailDel {vd}')
                else:
                    hhh.append(f'{kd} {vd}')
            else:
                kd = int(kd)
                if kd == sp:
                    hhh.append(f'HeadDel {vd}')
                elif kd >= ep:
                    hhh.append(f'TailDel {vd}')
                else:
                    hhh.append(f'{kd} {vd}')
        res = '; '.join(hhh)
    # elif len(__) == 1:
    #     res = __[0]
    else:
        res = '/'
    return res


def format_ins(__: list, sp: int, ep: int):
    ins_dict = {}
    if len(__) >= 1:
        if '/' in __:
            __.remove('/')
        for _ in __:
            info = _.split()
            if info[0] in ins_dict.keys():
                ins_dict[info[0]] += info[1]
            else:
                ins_dict[info[0]] = info[1]
        ins_dict = optimize_dict(ins_dict)
        hhh = []
        for kd, vd in ins_dict.items():
            if '-' in kd:
                if startpoint(kd) == sp:
                    hhh.append(f'HeadIns {vd}')
                elif endpoint(kd) >= ep:
                    hhh.append(f'TailIns {vd}')
                else:
                    hhh.append(f'{kd} {vd}')
            else:
                kd = int(kd)
                if kd == sp:
                    hhh.append(f'HeadIns {vd}')
                elif kd >= ep:
                    hhh.append(f'TailIns {vd}')
                else:
                    hhh.append(f'{kd} {vd}')
        res = '; '.join(hhh)
    # elif len(__) == 1:
    #     res = __[0]
    else:
        res = '/'
    return res


def optimize_dict(old_dict):
    key_list = list(old_dict.keys())
    new_dict = {}
    i = 0
    while i < len(key_list):
        new_value = old_dict[key_list[i]]
        new_key = key_list[i]

        if i == len(key_list) - 1:
            new_dict[new_key] = new_value
            i += 1
        else:
            if int(key_list[i]) == int(key_list[i + 1]) - 1:
                a = 1
                while a + i < len(key_list):
                    if int(key_list[i]) == int(key_list[i + a]) - a:
                        value_1 = old_dict[key_list[i + a]]
                        new_key = f'{key_list[i]}-{key_list[i + a]}'
                        new_value += value_1
                        a += 1
                    else:
                        break
                new_dict[new_key] = new_value
                i += a
            else:
                new_dict[new_key] = new_value
                i += 1

    return new_dict