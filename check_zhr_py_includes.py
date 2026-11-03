import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check include for ZHR_PY IT0008 method: usually ZHR_PY=======================CM003 or similar
# Let's search includes of ZHR_PY
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='D010INC',
           OPTIONS=[{'TEXT': "MASTER = 'ZHR_PY'"}])
for d in r.get('DATA', []):
    inc = d['WA'].strip()
    if 'CM' in inc:
        print("Include:", inc)
        r_inc = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
        lines = [l['LINE'] for l in r_inc.get('SOURCE_EXTENDED', [])]
        print(f"--- {inc} ({len(lines)} lines) ---")
        for l in lines[:40]:
            print(l)

c.close()

