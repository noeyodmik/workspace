import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check table SSFPSE or SSFPSEKEYS or SSFARGS
res = c.call('BBP_RFC_READ_TABLE', 
             QUERY_TABLE='SSFPSE',
             FIELDS=[{'FIELDNAME': 'MANDT'}, {'FIELDNAME': 'CONTEXT'}, {'FIELDNAME': 'APPLIC'}])

print("SSFPSE entries:")
for r in res['DATA']:
    print(r['WA'])

