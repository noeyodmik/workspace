import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='70000017', IV_MAX=5)
headers = r.get('ET_HEADERS', [])
messages = r.get('ET_MESSAGES', [])
print(f"Headers: {len(headers)}, Messages: {len(messages)}")

print("\nHeaders:")
for h in headers:
    print(f"Log: {h.get('LOGNUMBER')} | Date: {h.get('ALDATE')} {h.get('ALTIME')} | Ext: {h.get('EXTNUMBER')} | All: {h.get('MSG_CNT_AL')} | E: {h.get('MSG_CNT_E')}")

print("\nLast 20 Messages:")
for m in messages[-20:]:
    print(f"[{m.get('TYPE')}] {m.get('ID')}-{m.get('NUMBER')}: {m.get('MESSAGE')}")

c.close()

