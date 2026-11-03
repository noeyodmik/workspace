import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check STRUSTCERT
res = c.call('BBP_RFC_READ_TABLE', 
             QUERY_TABLE='STRUSTCERT',
             OPTIONS=[{'TEXT': "APPLIC = '100_SP'"}],
             FIELDS=[{'FIELDNAME': 'APPLIC'}, {'FIELDNAME': 'SUBJECT'}, {'FIELDNAME': 'CERTIFICATE'}])

print(f"Total certs in 100_SP: {len(res['DATA'])}")
for r in res['DATA']:
    print(r['WA'][:100])

