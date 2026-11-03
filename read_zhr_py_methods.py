import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

for inc in ['ZHR_PY========================CM001', 'ZHR_PY========================CM002', 'ZHR_PY========================CM003']:
    res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
    lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
    print(f"=== {inc} ({len(lines)} lines) ===")
    for idx, l in enumerate(lines, 1):
        print(f"{idx:03d}: {l}")

c.close()

