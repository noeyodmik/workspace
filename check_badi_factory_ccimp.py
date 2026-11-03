import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'CL_HRSFEC_BADI_CALL' + '=' * (30 - len('CL_HRSFEC_BADI_CALL')) + 'CCIMP'
r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=pad)
for idx, l in enumerate(r.get('SOURCE_EXTENDED', [])):
    if 'HRSFEC_B_CE_CHANGE_IT0008' in l['LINE'] or 'GET BADI' in l['LINE']:
        for x in r.get('SOURCE_EXTENDED', [])[max(0, idx-5):min(len(r.get('SOURCE_EXTENDED', [])), idx+20)]:
            print(x['LINE'])
        break

c.close()

