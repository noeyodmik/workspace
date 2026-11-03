import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Read STRUSTCERT for 100_EY and 100_SD
res = c.call('BBP_RFC_READ_TABLE', 
             QUERY_TABLE='STRUSTCERT',
             OPTIONS=[{'TEXT': "APPLIC = '100_EY' OR APPLIC = '100_SD'"}],
             FIELDS=[{'FIELDNAME': 'APPLIC'}, {'FIELDNAME': 'SUBJECT'}, {'FIELDNAME': 'ISSUER'}])

for r in res['DATA']:
    print(r['WA'])

