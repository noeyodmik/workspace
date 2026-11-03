import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_DATE_FROM='20261103', IV_DATE_TO='20261103', IV_MAX=50)

print('Total logs:', r.get('EV_TOTAL_LOGS'))
for h in r.get('ET_HEADERS', []):
    print(f"LOG: {h.get('LOGNUMBER')} | {h.get('SUBOBJECT')} | {h.get('EXTNUMBER')} | {h.get('ALTIME')}")

print(f"\nTotal messages: {len(r.get('ET_MESSAGES', []))}")
for m in r.get('ET_MESSAGES', []):
    print(f"[{m.get('TYPE')}] {m.get('ID')} {m.get('NUMBER')}: {m.get('MESSAGE')} / V1={m.get('MESSAGE_V1')}")

c.close()

