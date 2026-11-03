import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

c = Connection(**Settings("EA3").rfc_params())

res = c.call("Z_MCP_GET_REPLICATION_LOG",
             IV_DATE_FROM="20261030",
             IV_DATE_TO="20261030",
             IV_MAX=50)

print("EV_OK:", res.get("EV_OK"))
print("EV_MESSAGE:", res.get("EV_MESSAGE"))
print(f"Headers: {len(res.get('ET_HEADERS', []))}")
for h in res.get("ET_HEADERS", []):
    print(f"  Log: {h.get('LOGNUMBER')} Sub: {h.get('SUBOBJECT')} Ext: {h.get('EXTNUMBER')} Tot: {h.get('MSG_CNT_AL')} Err: {h.get('MSG_CNT_E')}")

# print only the latest log messages
headers = res.get("ET_HEADERS", [])
if headers:
    latest_log = headers[-1].get("LOGNUMBER")
    print(f"\n=== Messages for Latest Log {latest_log} ===")
    for m in res.get("ET_MESSAGES", []):
        print(f"  [{m.get('TYPE')}] {m.get('ID')} {m.get('NUMBER')}: {m.get('MESSAGE')} / V1={m.get('MESSAGE_V1')}")

