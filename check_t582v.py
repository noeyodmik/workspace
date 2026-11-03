import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check T582V for INFTY = 0002
res = c.call('BBP_RFC_READ_TABLE',
    QUERY_TABLE='T582V',
    DELIMITER='|',
    OPTIONS=[{'TEXT': "INFTY = '0002'"}]
)
print("--- T582V (INFTY=0002) ---")
for r in res['DATA']:
    print(r['WA'])

# Also check T77SFEC_C_SUP_IT
res2 = c.call('BBP_RFC_READ_TABLE',
    QUERY_TABLE='T77SFEC_C_SUP_IT',
    DELIMITER='|',
)
print("--- T77SFEC_C_SUP_IT ---")
for r in res2['DATA']:
    print(r['WA'])

c.close()

