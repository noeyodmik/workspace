import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('BBP_RFC_READ_TABLE', 
             QUERY_TABLE='STRUSTSSL', 
             OPTIONS=[{'TEXT': "APPLIC = '100_SD' OR APPLIC = '100_EY'"}])

for r in res['DATA']:
    print("STRUSTSSL:", r['WA'])

# Check text table STRUSTSSLT
res_t = c.call('BBP_RFC_READ_TABLE', 
               QUERY_TABLE='STRUSTSSLT', 
               OPTIONS=[{'TEXT': "APPLIC = '100_SD' OR APPLIC = '100_EY'"}])

for r in res_t['DATA']:
    print("STRUSTSSLT:", r['WA'])

