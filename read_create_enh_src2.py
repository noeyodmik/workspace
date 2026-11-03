import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad_m = 'CL_ENH_FACTORY' + '=' * (30 - len('CL_ENH_FACTORY')) + 'CM008'
r_m = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=pad_m)
lines = [l['LINE'] for l in r_m.get('SOURCE_EXTENDED', [])]
for idx, l in enumerate(lines[60:]):
    print(f"{idx+61:03d}: {l}")

c.close()

