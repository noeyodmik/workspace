import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'CL_HRSFEC_EE_MDR_COMP_XX' + '=' * (30 - len('CL_HRSFEC_EE_MDR_COMP_XX'))

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=f"{pad}CM018")
lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
print(f"=== CM018: PROCESS_COMPENSATION ({len(lines)} lines) ===")
for idx, l in enumerate(lines[:60]):
    print(f"{idx+1:03d}: {l}")

