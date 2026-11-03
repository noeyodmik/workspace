import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_DATE_FROM='20261103', IV_DATE_TO='20261103', IV_MAX=500)
ms = r.get('ET_MESSAGES', [])
print(f"Total messages: {len(ms)}")

for i, m in enumerate(ms):
    tx = m.get('MESSAGE', '')
    if any(k in tx for k in ['paycompensation', 'pay_component', 'SEPPIN_BaseSalary', 'compensation_information', 'paycompvalue']):
        print(f"--- MSG {i} ({m.get('TYPE')}) ---")
        print(tx[:500])

c.close()

