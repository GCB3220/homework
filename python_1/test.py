import xml.dom.minidom as minidom
import xlwt

workbook = xlwt.Workbook()
sheet = workbook.add_sheet('autophagosome')

dom = minidom.parse('go_obo.xml')
terms = dom.getElementsByTagName('term')


def find_terms(is_a_id):
    count = 0
    for term in terms:
        is_a = term.getElementsByTagName('is_a')
        if is_a:
            if is_a[0].firstChild.nodeValue == is_a_id:
                count += 1
                id = term.getElementsByTagName('id')[0].firstChild.nodeValue
                find_terms(id)
        else:
            print(f'Term {term.getElementsByTagName("id")[0].firstChild.nodeValue} has no is_a')
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
        is_a = term.getElementsByTagName('is_a')[0]
        is_a_id = is_a.firstChild.nodeValue
        child_count = find_terms(is_a_id)

        sheet.write(row, 0, term_id)
        sheet.write(row, 1, term_name)
        sheet.write(row, 2, term_def)
        sheet.write(row, 3, child_count)
        row += 1

workbook.save('autophagosome.xls')