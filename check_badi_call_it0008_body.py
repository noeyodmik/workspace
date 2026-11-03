import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'CL_HRSFEC_BADI_CALL' + '=' * (30 - len('CL_HRSFEC_BADI_CALL')) + 'CCIMP'
r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=pad)
lines = [l['LINE'] for l in r.get('SOURCE_EXTENDED', [])]
for idx, l in enumerate(lines):
    if 'HRSFEC_B_CE_CHANGE_IT0008' in l and 'METHOD' in l:
        print("FOUND METHOD:")
        for x in lines[idx:min(len(lines), idx+30)]:
            print(x)
        break

c.close()

