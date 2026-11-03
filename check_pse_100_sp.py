import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check SSFP_GET_PSEINFO for 100_SP
try:
    res = c.call('SSFP_GET_PSEINFO', APPLIC='100_SP')
    print("100_SP PSE exists! Subject:", res.get('SUBJECT'))
except Exception as e:
    print("100_SP error:", e)

# Check ICM cache or status
res_icm = c.call('BBP_RFC_READ_TABLE', 
                 QUERY_TABLE='ICM_STAT', 
                 ROWCOUNT=5)
for r in res_icm.get('DATA', []):
    print("ICM:", r['WA'])

