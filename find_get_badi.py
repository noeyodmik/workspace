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
    if 'GET BADI' in l:
        print(f"FOUND AT LINE {idx+1}:")
        for x in lines[max(0, idx-5):min(len(lines), idx+15)]:
            print(x)

c.close()

