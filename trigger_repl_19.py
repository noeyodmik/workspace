import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

print("Calling Z_MCP_GET_REPLICATION_LOG with IV_EXT_ID='70000019', IV_TRIGGER_REPL='X'...")
# First try with IV_CONFIG_ID = 'DEFAULT'
r = c.call('Z_MCP_GET_REPLICATION_LOG',
           IV_EXT_ID='70000019',
           IV_CONFIG_ID='DEFAULT',
           IV_TRIGGER_REPL='X',
           IV_DATE_FROM='20261103',
           IV_DATE_TO='20261103',
           IV_MAX=50)

print(f"EV_OK: {r.get('EV_OK')}, EV_MESSAGE: {r.get('EV_MESSAGE')}")
print(f"ET_LOGS: {len(r.get('ET_LOGS', []))}")
for log in r.get('ET_LOGS', []):
    print("LOG:", log.get('LOGNUMBER'), log.get('EXTNUMBER'), log.get('ALDATE'), log.get('ALTIME'), log.get('MSG_CNT_AL'))

print(f"ET_MESSAGES: {len(r.get('ET_MESSAGES', []))}")
for m in r.get('ET_MESSAGES', []):
    print(f"[{m.get('TYPE')}] {m.get('ID')} {m.get('NUMBER')}: {m.get('MESSAGE')} / V1={m.get('MESSAGE_V1')} V2={m.get('MESSAGE_V2')}")

c.close()

