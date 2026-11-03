import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Query BALDAT/BALM or Z_MCP_GET_REPLICATION_LOG for 70000019
r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_DATE_FROM='20261103', IV_DATE_TO='20261103', IV_MAX=500)
for m in r.get('ET_MESSAGES', []):
    tx = m.get('MESSAGE') or ''
    if '70000019' in tx or '인사 번호' in tx:
        print(f"{m.get('TYPE')} | {m.get('ID')} {m.get('NUMBER')} | {tx}")

c.close()

