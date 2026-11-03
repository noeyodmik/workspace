import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

name = 'CL_ENH_TOOL_BADI_DEF'
prog = name + '=' * (30 - len(name)) + 'CU'
r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
lines = [l['LINE'] for l in r.get('SOURCE_EXTENDED', [])]
print(f"Total lines: {len(lines)}")
for idx, l in enumerate(lines):
    if 'GET_BADI' in l or 'BADIS' in l:
        print(f"--- Around line {idx} ---")
        for x in lines[max(0, idx-2):min(len(lines), idx+10)]:
            print(x)

c.close()

