import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

inc = 'CL_HRSFEC_PTP_EE_REPLICATION==CM00N'
r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
print(f"=== {inc} ===")
for l in r.get('SOURCE_EXTENDED', []):
    print(l['LINE'])

c.close()

