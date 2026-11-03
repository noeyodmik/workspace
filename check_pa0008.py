import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T582A', DELIMITER='|',
           OPTIONS=[{'TEXT': "INFTY = '0008'"}],
           FIELDS=[{'FIELDNAME': 'INFTY'}, {'FIELDNAME': 'SUBTY'}, {'FIELDNAME': 'ZEITY'}])
print("T582A (0008):", [x['WA'] for x in r['DATA']])

# Check existing PA0008 records in client 100
r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='PA0008', DELIMITER='|',
            FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'SUBTY'}, {'FIELDNAME': 'BEGDA'}, {'FIELDNAME': 'ENDDA'}, {'FIELDNAME': 'TRFAR'}, {'FIELDNAME': 'TRFGB'}, {'FIELDNAME': 'TRFGR'}, {'FIELDNAME': 'TRFST'}])
print("PA0008 count:", len(r2['DATA']))
for x in r2['DATA'][:10]:
    print(x['WA'])

