import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOSUBCO', DELIMITER='|',
           OPTIONS=[{'TEXT': "CLSNAME = 'IF_HRSFEC_CE_CHANGE_IT0008'"}],
           FIELDS=[{'FIELDNAME': 'CMPNAME'}, {'FIELDNAME': 'SCONAME'}, {'FIELDNAME': 'PAROPTIONL'}, {'FIELDNAME': 'TYPTYPE'}, {'FIELDNAME': 'TYPE'}])
for x in r['DATA']:
    print(x['WA'].strip())

c.close()

