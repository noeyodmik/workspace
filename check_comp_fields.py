import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L', DELIMITER='|',
           OPTIONS=[{'TEXT': "TABNAME LIKE 'PAD_SFEC%COMP%REC%'"}],
           FIELDS=[{'FIELDNAME': 'TABNAME'}, {'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'ROLLNAME'}, {'FIELDNAME': 'DOMNAME'}])
print("DD03L:", len(r['DATA']))
for d in r['DATA']:
    print(d['WA'].strip())

c.close()

