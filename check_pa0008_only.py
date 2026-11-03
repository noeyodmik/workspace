import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='PA0008', DELIMITER='|',
            FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'SUBTY'}, {'FIELDNAME': 'BEGDA'}, {'FIELDNAME': 'ENDDA'}, {'FIELDNAME': 'TRFAR'}, {'FIELDNAME': 'TRFGB'}, {'FIELDNAME': 'TRFGR'}, {'FIELDNAME': 'TRFST'}, {'FIELDNAME': 'LGA01'}, {'FIELDNAME': 'BET01'}])
print("PA0008 count:", len(r2['DATA']))
for x in r2['DATA'][:10]:
    print(x['WA'])

