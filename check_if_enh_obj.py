import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'IF_ENH_OBJECT' + '=' * (30 - len('IF_ENH_OBJECT')) + 'IU'
r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=pad)
for l in r.get('SOURCE_EXTENDED', []):
    if any(k in l['LINE'] for k in ['SAVE', 'ACTIVATE', 'UNLOCK']):
        print(l['LINE'])

c.close()

