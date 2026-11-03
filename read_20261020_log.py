import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

c = Connection(**Settings("EA3").rfc_params())

res = c.call("Z_MCP_GET_REPLICATION_LOG",
             IV_DATE_FROM="20261020",
             IV_DATE_TO="20261020",
             IV_MAX=100)

print("EV_OK:", res.get("EV_OK"))
print("EV_MESSAGE:", res.get("EV_MESSAGE"))
print(f"Headers: {len(res.get('ET_HEADERS', []))}")
for h in res.get('ET_HEADERS', []):
    print(f"  Log: {h.get('LOGNUMBER')} Sub: {h.get('SUBOBJECT')} Ext: {h.get('EXTNUMBER')} Tot: {h.get('MSG_CNT_AL')} Err: {h.get('MSG_CNT_E')}")

for m in res.get("ET_MESSAGES", []):
    print(f"  Log {m.get('LOGNUMBER')} [{m.get('TYPE')}] {m.get('ID')} {m.get('NUMBER')}: {m.get('MESSAGE')} / V1={m.get('MESSAGE_V1')}")

