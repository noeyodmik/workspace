import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('RPY_PROGRAM_READ', 
             PROGRAM_NAME='RP_HRSFEC_PTP_CONFIGURATION')

lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
for i, line in enumerate(lines[200:350], start=200):
    print(f"{i}: {line}")

