import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('BBP_RFC_READ_TABLE', 
             QUERY_TABLE='DD03L', 
             OPTIONS=[{'TEXT': "TABNAME = 'PAD_SFEC_CE_PAYCOMP_RECURRING' AND "},
                      {'TEXT': "FIELDNAME = 'PAY_COMPONENT'"}],
             FIELDS=[{'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'ROLLNAME'}, {'FIELDNAME': 'DOMNAME'}, {'FIELDNAME': 'LENG'}])

for r in res['DATA']:
    print(r['WA'])

c.close()
