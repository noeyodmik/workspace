import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='RP_HRSFEC_DATA_RECOVERY')
lines = [l['LINE'] for l in r.get('SOURCE_EXTENDED', [])]
print(f"Total lines in RP_HRSFEC_DATA_RECOVERY: {len(lines)}")
for idx, l in enumerate(lines[:60]):
    print(f"{idx+1}: {l}")

c.close()

