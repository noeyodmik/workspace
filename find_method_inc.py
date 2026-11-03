import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

for m in ['PROCESS_BASIC_PAY', 'MAP_BASIC_PAY', 'PROCESS_COMPENSATION']:
    try:
        r = c.call('SEO_METHOD_GET_INCLUDE',
                   MSKEY={'CLSNAME': 'CL_HRSFEC_EE_MDR_COMP_XX', 'CPDNAME': m})
        print(m, r.get('INC_NAME'))
    except Exception as e:
        print(m, e)

