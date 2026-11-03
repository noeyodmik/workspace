import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

print("Querying Log 00000000000000040063...")
r = c.call('Z_MCP_GET_REPLICATION_LOG',
           IV_DATE_FROM='20261103',
           IV_DATE_TO='20261103',
           IV_EXT_ID='70000017',
           IV_MAX=100)

for m in r.get('ET_MESSAGES', []):
    # filter for log 40063
    # let's print all
    print(f"[{m.get('LOG_MSG_NO')}] [{m.get('TYPE')}] {m.get('ID')} {m.get('NUMBER')}: {m.get('MESSAGE')} / V1={m.get('MESSAGE_V1')} V2={m.get('MESSAGE_V2')}")

c.close()
