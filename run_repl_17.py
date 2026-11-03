import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 정식 경로: Z_MCP_GET_REPLICATION_LOG 의 IV_TRIGGER_REPL (SUBMIT RP_HRSFEC_PTP_EE_REPLICATION P_EXTID2)
r = c.call('Z_MCP_GET_REPLICATION_LOG',
           IV_EXT_ID='70000017',
           IV_CONFIG_ID='DEFAULT',
           IV_TRIGGER_REPL='X',
           IV_DATE_FROM='20261103',
           IV_DATE_TO='20261103',
           IV_MAX=50)
print("EV_OK:", r.get('EV_OK'), "|", r.get('EV_MESSAGE'))
for h in r.get('ET_HEADERS', []):
    print("LOG:", h.get('LOGNUMBER'), h.get('SUBOBJECT'), h.get('EXTNUMBER'), h.get('ALTIME'), h.get('MSG_CNT_E'))
for m in r.get('ET_MESSAGES', []):
    if m.get('TYPE') in ('E', 'A', 'W') or m.get('ID') in ('RP',):
        print(f"[{m.get('TYPE')}] {m.get('ID')} {m.get('NUMBER')}: {m.get('MESSAGE')}")
c.close()

