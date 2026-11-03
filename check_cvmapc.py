import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check T77SFEC_CVMAPC
res = c.call('RFC_READ_TABLE',
    QUERY_TABLE='T77SFEC_CVMAPC',
    DELIMITER='|',
    OPTIONS=[{"TEXT": "EC_DATA_TYPE = 'PAY_COMPONENT'"}]
)

print("--- T77SFEC_CVMAPC (PAY_COMPONENT) ---")
for r in res['DATA']:
    print(r['WA'])

# Also check T77SFEC_CVMAP (header)
res2 = c.call('RFC_READ_TABLE',
    QUERY_TABLE='T77SFEC_CVMAP',
    DELIMITER='|',
    OPTIONS=[{"TEXT": "EC_DATA_TYPE = 'PAY_COMPONENT'"}]
)
print("--- T77SFEC_CVMAP (PAY_COMPONENT) ---")
for r in res2['DATA']:
    print(r['WA'])

c.close()
