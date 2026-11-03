import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

cls = 'CL_HRSFEC_CODE_VALUE_MAPPING'
pad = cls + '=' * (30 - len(cls))
for i in [1, 2, 3, 7]:
    inc = pad + 'CM%03d' % i
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
        print(f"=== {inc} ===")
        for idx, l in enumerate(res.get('SOURCE_EXTENDED', [])):
            print(f"{idx:03d}: {l['LINE']}")
    except Exception as e:
        print(inc, e)

# Also print all messages from today's run after 08:28:25 (which is 70000019)
r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_DATE_FROM='20261030', IV_DATE_TO='20261030', IV_MAX=50)
ms = r.get('ET_MESSAGES', [])
in_19 = False
print("=== 70000019 messages (08:28:29~) ===")
for m in ms:
    tx = m.get('MESSAGE') or ''
    if '2026-10-30 08:28:29' in tx:
        in_19 = True
    if in_19:
        if '2026-10-30 04:' in tx:
            break
        if m.get('ID') == 'HRSFEC_PTP' and m.get('NUMBER') == '102':
            continue
        print(m.get('TYPE'), m.get('ID'), m.get('NUMBER'), tx)

