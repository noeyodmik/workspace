import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='CL_HRSFEC_EE_MDR_COMP_XX======CM009')
lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
print(f"=== CL_HRSFEC_EE_MDR_COMP_XX======CM009 ({len(lines)} lines) ===")
for idx in range(120, min(170, len(lines))):
    print(f"{idx+1:03d}: {lines[idx]}")

