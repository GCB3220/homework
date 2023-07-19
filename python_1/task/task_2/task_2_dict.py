import pandas as pd
import re
from pprint import pprint

z = 0
df_class = pd.read_csv(f'C:/a/y-code/python1/file/update_1/{z}.csv')
class_list = df_class['structure_info'].tolist()

update_list = []
update_list_0 = []

special_list_5 = ['CTP', 'ATCase', 'II', 'GPG', 'III', 'VI', 'IV', 'VII', 'HIV', 'CheA', 'CGI', 'UvrB', 'RT',
                  'Apo2L', 'rRNA', 'NMT', 'IIb', 'ATP', 'tRNA', 'NlpC', 'DNA', 'Asp98Asn', 'IIIe', 'RNA', 'HCV', 'DR',
                  'MHC', 'SOS', 'S4AFL3ARG515', 'ATPase', 'PACAP21', 'IgG2a', 'UUA3', 'CcdBVfi', 'PHA', 'ADP',
                  'UMP', 'CMP', 'GTPase', 'VEGFR2', 'DigA16', 'NADP', 'AZTP5A', 'DXPS', 'ERK', 'IRES', 'FMD',
                  'pCpGpCpGpCpG', 'MR', 'PD235', 'PNGase', 'HCC', 'MMP', 'SH', 'CD', 'PA', 'FMN', 'HPK1',
                  'VP1', 'Spo0F', 'TAR', 'PKF', 'DMP', 'dTMP', 'MET', 'LIF', 'ABA', 'Thr119Met', 'FKBP', 'SRF'
                  'RGS', 'HPLC', 'HOD', 'Cys2His2', 'Thr252Ile', 'P450cam', 'vMIP', 'GNA', 'CB', 'HDS1', 'IgA1',
                  'BP', 'AmpC', 'YebC', 'GMPPCP', 'HlgB', 'YjiA', 'DP', 'kD', 'YgfZ', 'RADA', 'FHPA', 'FRB', 'OPG2',
                  'TBP', 'EaeA', 'BACE2', 'EM', 'HRV16', 'D1D2', 'ICAM', 'APS', 'PCB', 'JAK1', 'PV2L', 'HAH1',
                  'FcgRIII', 'GDP', 'IMI', 'MDM2', 'TRIM21', 'FDX', 'HSD1', 'CBTAU', 'UP1', 'PTPN5', 'KH', 'hnRNP',
                  'TNK', 'GH92', 'BT2199', 'VPI', 'apoE', 'PD', 'ssDNA', 'NH', 'PO', 'FHTG', 'BPTI', 'SDF', 'SN'
                  'P16INK4a', 'HLA', 'BCL', 'EBNA', 'MoMLV', 'CH2H4folate', 'NaI', '1BB', 'W3A1', 'EF', 'CPD', 'MS2',
                  'U2AF65', 'BRU5G6', 'IgG1', 'GAP', 'AlF4', 'GT', 'KDO8P', 'EDE2', 'TyrR', 'GppNHp', 'INK4b'
                  'GMPPCP', 'AMPPNP', 'CoA', 'Mbp1', 'PKA', 'CGPS', 'GMP', 'HMG', 'PP2A', 'PR65alpha', 'NGF', 'CaII',
                  'VIII', 'GluR2', 'TrkA', 'dTDP', 'Sr2', 'GPPNHP', 'PPIN', 'IgG', 'CK2', 'PETT', 'Thr157', 'GlpF',
                  'pYEEI', 'NTRC', 'EphB2', 'NII', 'GM1', ' DsbA', 'HXBc2', 'PEPP', 'CPD', 'DNase', 'MgAMPPCP',
                  'S1S2J', 'CCCP', 'CYP106A1', 'GppNHp', 'GMPPCP', 'CRH', 'IIa', 'ASFP', 'GlcNAc', 'D1D2',
                  'FKBP', 'HNF', 'mm', 'TDP', 'BPN', 'NAD', '4Fe', 'GFP', 'NIPP', 'LM', 'HT', 'EFR', 'CMK',
                  ]

# number+word*2+number4/5
# word+number+word 4/5/6?
# CGTAU NUMBER ag3[t2ag3]3
# PKF273 HPK1
# sn6999 cgl0226* >4
# Thr252Ile >6
# MS2 KH2
# Cu Zn Mg Fe As Sb
q = 1
p = 1
for i in class_list:
    if i.upper() == i:
        update_list.append(i.capitalize())
        q = q+1


for i in class_list:
    if re.search(r'pd', i):
        update_list_0.append(i.capitalize())
        p = p+1
pprint(update_list)
print(q)