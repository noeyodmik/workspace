import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_DATE_FROM='20261103', IV_DATE_TO='20261103', IV_MAX=500)
ms = r.get('ET_MESSAGES', [])
print(f"Total messages today: {len(ms)}")
in_40063 = False
for m in ms:
    tx = m.get('MESSAGE') or ''
    # Filter for the run around 00:39
    if '00:39:46' in tx or '70000017' in tx:
        in_40063 = True
    if in_40063:
        if m.get('ID') == 'HRSFEC_PTP' and m.get('NUMBER') == '102':
            continue
        print(f"{m.get('TYPE')} | {m.get('ID')} {m.get('NUMBER')} | {tx}")

