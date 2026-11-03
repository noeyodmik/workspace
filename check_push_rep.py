import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

c = Connection(**Settings("EA3").rfc_params())

# Check how HTTP destination is determined in PTP
# Check table T77SFEC_PUSH_REP or T77SFEC_PTP_CONF
# Or check references to RFCDES
res = c.call("BBP_RFC_READ_TABLE",
    QUERY_TABLE="T77SFEC_PUSH_REP",
    ROWCOUNT=10
)
print("=== T77SFEC_PUSH_REP ===")
for r in res.get("DATA", []):
    print(" ", r["WA"].strip())

