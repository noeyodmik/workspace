import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('Z_MCP_GET_REPLICATION_LOG',
           IV_DATE_FROM='20261103',
           IV_DATE_TO='20261103',
           IV_SUBOBJECT='EMPLOYEE',
           IV_EXT_ID='70000019',
           IV_MAX=10)

print("EV_OK:", r.get('EV_OK'), "EV_MSG:", r.get('EV_MESSAGE'))
for h in r.get('ET_HEADERS', []):
    print("LOG:", h.get('LOGNUMBER'), h.get('SUBOBJECT'), h.get('EXTNUMBER'), h.get('ALDATE'), h.get('ALTIME'))

print(f"Messages count: {len(r.get('ET_MESSAGES', []))}")
for m in r.get('ET_MESSAGES', []):
    print(f"[{m.get('TYPE')}] {m.get('ID')} {m.get('NUMBER')}: {m.get('MESSAGE')} / V1={m.get('MESSAGE_V1')} V2={m.get('MESSAGE_V2')}")

c.close()

