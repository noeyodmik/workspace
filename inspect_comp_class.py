import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Read CP (class pool) or CU (public section)
res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='CL_HRSFEC_EE_MDR_COMP_XX======CU')
for l in res.get('SOURCE_EXTENDED', []):
    print(l['LINE'])

