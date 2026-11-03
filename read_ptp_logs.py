import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('Z_MCP_GET_REPLICATION_LOG',
           IV_DATE_FROM='20261103',
           IV_DATE_TO='20261103',
           IV_SUBOBJECT='EMPLOYEE_PTP',
           IV_MAX=50)

print("EV_MESSAGE:", r.get('EV_MESSAGE'))
print("ET_HEADERS:", len(r.get('ET_HEADERS', [])))
for h in r.get('ET_HEADERS', []):
    print(" H:", h.get('LOGNUMBER'), h.get('EXTNUMBER'), h.get('ALDATE'), h.get('ALTIME'), h.get('MSG_CNT_AL'))

print("ET_MESSAGES:", len(r.get('ET_MESSAGES', [])))
for m in r.get('ET_MESSAGES', []):
    print(f" [{m.get('TYPE')}] {m.get('ID')} {m.get('NUMBER')}: {m.get('MESSAGE')} / V1={m.get('MESSAGE_V1')}")

c.close()

