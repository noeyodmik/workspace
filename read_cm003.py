import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

inc_name = 'ZHR_PY' + '=' * 24 + 'CM003'
r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc_name)
lines = [l['LINE'] for l in r.get('SOURCE_EXTENDED', [])]
print(f"Total lines in {inc_name}: {len(lines)}")
for idx, l in enumerate(lines):
    print(f"{idx+1}: {l}")

c.close()

