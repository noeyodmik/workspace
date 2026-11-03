import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
for idx, l in enumerate(r.get('SOURCE_EXTENDED', [])[30:90]):
    print(f"{idx+31:03d}: {l['LINE']}")

c.close()

