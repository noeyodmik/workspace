import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

cls = 'CL_HRSFEC_PTP_SERVICE_LIB' + '=' * 5 + 'CM004'
r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=cls)
print(f"=== {cls} ===")
for l in r.get('SOURCE_EXTENDED', []):
    print(l['LINE'])

c.close()
