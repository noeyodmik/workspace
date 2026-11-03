import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('Z_MCP_GET_REPLICATION_LOG',
           IV_DATE_FROM='20261103',
           IV_DATE_TO='20261103',
           IV_MAX=50)

for m in r.get('ET_MESSAGES', []):
    if m.get('LOGNUMBER') == '00000000000000040069':
        print(f"[{m.get('TYPE')}] {m.get('ID')} {m.get('NUMBER')}: {m.get('MESSAGE')} / V1={m.get('MESSAGE_V1')} V2={m.get('MESSAGE_V2')}")

c.close()

