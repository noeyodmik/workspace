import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r_log = c.call('Z_MCP_GET_REPLICATION_LOG', IV_PERNR='70000017')
details = r_log.get('ET_LOG_DETAILS', [])
print(f"Total details: {len(details)}")
for l in details[-30:]:
    print(f"[{l.get('MSGTY')}] {l.get('MSGID')}-{l.get('MSGNO')}: {l.get('MESSAGE')}")

c.close()

