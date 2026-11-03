import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Search for classes or programs mentioning SAP Cloud Platform Client CA or STRUST in HRSFEC
res = c.call('RPY_PROGRAM_READ', 
             PROGRAM_NAME='CL_HRSFEC_CERT_EXPORT==========CP')

lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
print(f"CL_HRSFEC_CERT_EXPORT lines: {len(lines)}")
for line in lines[:50]:
    print(line)

