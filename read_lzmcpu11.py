import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
for i, l in enumerate(orig_lines[:45], 1):
    print(f"{i:03d}: {l}")

