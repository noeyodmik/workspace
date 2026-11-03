import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check HRSFEC_D_EEKEYMP for 70000017
res_key = c.call('BBP_RFC_READ_TABLE', 
                 QUERY_TABLE='HRSFEC_D_EEKEYMP',
                 OPTIONS=[{'TEXT': "EMPLOYEE_ID_EXT = '70000017'"}])
print("HRSFEC_D_EEKEYMP for 70000017:")
for r in res_key['DATA']:
    print(r['WA'])

# Check PA0709
res_709 = c.call('BBP_RFC_READ_TABLE', 
                 QUERY_TABLE='PA0709',
                 OPTIONS=[{'TEXT': "PERID = '70000017'"}])
print("PA0709 for 70000017:")
for r in res_709['DATA']:
    print(r['WA'])

