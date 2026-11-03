import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

print("Querying logs for 70000017...")
r = c.call('Z_MCP_GET_REPLICATION_LOG',
           IV_DATE_FROM='20261103',
           IV_DATE_TO='20261103',
           IV_EXT_ID='70000017',
           IV_MAX=100)

print("OK:", r.get('EV_OK'))
print("Message:", r.get('EV_MESSAGE'))
print(f"Total Headers: {len(r.get('ET_HEADERS', []))}")
for h in r.get('ET_HEADERS', []):
    print(f"Log: {h.get('LOGNUMBER')} | Sub: {h.get('SUBOBJECT')} | Ext: {h.get('EXTNUMBER')} | All: {h.get('MSG_CNT_AL')} | E: {h.get('MSG_CNT_E')}")

print(f"\nTotal Messages: {len(r.get('ET_MESSAGES', []))}")
for m in r.get('ET_MESSAGES', []):
    if m.get('ID') == 'HRSFEC_PTP' and m.get('NUMBER') == '102':
        continue
    print(f"[{m.get('TYPE')}] {m.get('ID')} {m.get('NUMBER')}: {m.get('MESSAGE')} / V1={m.get('MESSAGE_V1')} V2={m.get('MESSAGE_V2')}")

c.close()

