import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# classes related to code value mapping
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOCLASS',
           OPTIONS=[{'TEXT': "CLSNAME LIKE 'CL_HRSFEC%MAP%' OR"},
                    {'TEXT': "CLSNAME LIKE 'CL_HRSFEC%COD%' OR"},
                    {'TEXT': "CLSNAME LIKE 'CL_HRSFEC%CVM%'"}],
           FIELDS=[{'FIELDNAME': 'CLSNAME'}])
print('CLASSES:', [x['WA'].strip() for x in r['DATA']])

# message class HRSFEC_COD_MAPPING usage: find message texts
m = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T100',
           OPTIONS=[{'TEXT': "SPRSL = '3' AND ARBGB = 'HRSFEC_COD_MAPPING' AND MSGNR = '015'"}],
           FIELDS=[{'FIELDNAME': 'TEXT'}])
print('MSG015:', [x['WA'] for x in m['DATA']])

# which EC data types does the mapping property table know
p = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_CVPROPC', DELIMITER='|')
print('CVPROPC FLDS:', [x['FIELDNAME'] for x in p['FIELDS']])
for x in p['DATA'][:40]:
    print(x['WA'])
p2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_CVPROPS', DELIMITER='|')
print('CVPROPS rows:', len(p2['DATA']))
for x in p2['DATA']:
    if 'CONTRACT' in x['WA'] or 'EMPLOYEE_' in x['WA'] or 'CLASS' in x['WA']:
        print(x['WA'])

