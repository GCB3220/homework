import xml.dom.minidom as minidom
import xlwt

workbook = xlwt.Workbook()
sheet = workbook.add_sheet('GO terms')

dom = minidom.parse('go_obo.xml')
terms = dom.getElementsByTagName('term')

def get_child_count(term):
    count = 0
    is_a = term.getElementsByTagName('is_a')[0].firstChild.data
    child_id = []
    child_id.append(is_a)
    for term1 in terms:
        id = term1.getElementsByTagName('id')[0].firstChild.data
        if id in child_id:
            count += 1
            child_id.append(term1.getElementsByTagName('is_a')[0].firstChild.data)

    return count








row = 1
sheet.write(0, 0, 'id')
sheet.write(0, 1, 'name')
sheet.write(0, 2, 'def')
sheet.write(0, 3, 'chlidnote')
for term in terms:
    term_def = term.getElementsByTagName('defstr')[0].firstChild.data

    if 'autophagosome' in term_def:
        term_id = term.getElementsByTagName('id')[0].firstChild.data
        term_name = term.getElementsByTagName('name')[0].firstChild.data
        count = get_child_count(term)


        sheet.write(row, 0, term_id)
        sheet.write(row, 1, term_name)
        sheet.write(row, 2, term_def)
        sheet.write(row, 3, count)
        row += 1

workbook.save('GO_terms.xls')
