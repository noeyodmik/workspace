import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

for prog in ['LZMCPTOP', 'SAPLZMCP']:
    try:
        r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
        lines = [l['LINE'] for l in r.get('SOURCE_EXTENDED', [])]
        print(f"--- {prog} ({len(lines)} lines) ---")
        for l in lines:
            print(l)
    except Exception as e:
        print(f"Error {prog}: {e}")

c.close()

