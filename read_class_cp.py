import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='CL_HRSFEC_PTP_EE_REPLICATION===CP')
lines = [l['LINE'] for l in r.get('SOURCE_EXTENDED', [])]
print(f"Total lines in CP: {len(lines)}")
for l in lines:
    print(l)

c.close()

