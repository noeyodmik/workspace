import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('SEO_METHOD_GET_INCLUDE',
           MTDKEY={'CLSNAME': 'CL_HRSFEC_EE_MDR_COMP_XX', 'CPDNAME': 'CALL_BADI_CHANGE_IT0008'})
print("Include name:", r.get('INC_NAME'))

r2 = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=r.get('INC_NAME'))
for idx, l in enumerate(r2.get('SOURCE_EXTENDED', [])):
    print(f"{idx+1:03d}: {l['LINE']}")

c.close()

