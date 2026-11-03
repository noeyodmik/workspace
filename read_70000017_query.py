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
             IV_TIME_FROM="101700",
             IV_TIME_TO="101900",
             IV_MAX=100)

for m in res.get("ET_MESSAGES", []):
    print(f"[{m.get('TYPE')}] {m.get('ID')} {m.get('NUMBER')}: {m.get('MESSAGE')} / V1={m.get('MESSAGE_V1')}")

