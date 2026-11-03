import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())
r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='RP_HRSFEC_PTP_EE_REPLICATION')
lines = [l['LINE'] for l in r.get('SOURCE_EXTENDED', [])]
for i in range(25, min(90, len(lines))):
    print(f"{i+1}: {lines[i]}")
c.close()

