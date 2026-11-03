import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())
r = c.call('SEO_METHOD_GET_INCLUDE',
           MTDKEY={'CLSNAME': 'CL_HRSFEC_PTP_EE_REPLICATION', 'CPDNAME': 'INVOKE_INBOUND_WS'})
inc = r.get('INC_NAME')
print("Include:", inc)
if inc:
    r_src = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
    for idx, l in enumerate(r_src.get('SOURCE_EXTENDED', [])):
        print(f"{idx+1}: {l.get('LINE')}")

c.close()

