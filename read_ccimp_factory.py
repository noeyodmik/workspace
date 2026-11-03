import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='CL_HRSFEC_BADI_CALL===========CCIMP')
lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
print(f"Total lines in CCIMP: {len(lines)}")
in_0008 = False
for idx, l in enumerate(lines):
    if '0008' in l:
        in_0008 = True
        print(f"L{idx+1}: {l}")
        for j in range(idx+1, min(len(lines), idx+30)):
            print(f"  {j+1}: {lines[j]}")
        break

