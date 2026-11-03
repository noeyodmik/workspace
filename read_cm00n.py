import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='CL_HRPA_INFOTYPE_CONTAINER====CM00N')
lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
for idx, l in enumerate(lines, 1):
    print(f"{idx:03d}: {l}")

c.close()
