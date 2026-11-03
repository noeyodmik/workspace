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
print(f"Total lines: {len(lines)}")
for i, line in enumerate(lines):
    if 'MODIFY_RFC_DESTINATION' in line:
        for j in range(max(0, i-5), min(len(lines), i+45)):
            print(f"{j}: {lines[j]}")
        break

