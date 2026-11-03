import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('RPY_PROGRAM_READ', 
             PROGRAM_NAME='RP_HRSFEC_PTP_CONFIG_HELPER')

lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
for i, line in enumerate(lines):
    if 'gv_dest_soap' in line.lower() and ('=' in line or 'data' in line.lower()):
        print(f"{i}: {line}")

