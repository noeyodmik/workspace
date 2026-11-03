import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TFDIR',
           OPTIONS=[{'TEXT': "FUNCNAME LIKE 'TR_APPEND%' OR"},
                    {'TEXT': "FUNCNAME LIKE 'TR_OBJECTS_INSERT%' OR"},
                    {'TEXT': "FUNCNAME LIKE 'TR_REQUEST_CHOICE%' OR"},
                    {'TEXT': "FUNCNAME LIKE 'TR_OBJECT_INSERT%'"}],
           FIELDS=[{'FIELDNAME': 'FUNCNAME'}])
names = [x['WA'].strip() for x in r['DATA']]
print('FMs:', names)
for n in names:
    p = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='FUPARAREF', DELIMITER='|',
               OPTIONS=[{'TEXT': "FUNCNAME = '%s'" % n}],
               FIELDS=[{'FIELDNAME': 'PARAMETER'}, {'FIELDNAME': 'PARAMTYPE'}, {'FIELDNAME': 'STRUCTURE'}])
    print('==', n)
    for x in p['DATA']:
        print('  ', x['WA'])

