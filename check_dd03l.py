import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('BBP_RFC_READ_TABLE',
    QUERY_TABLE='DD03L',
    DELIMITER='|',
    OPTIONS=[{'TEXT': "TABNAME = 'T77SFEC_CVMAPC' AND FIELDNAME = 'EC_CODE_VALUE'"}]
)

for r in res['DATA']:
    print(r['WA'])

# Check domain HRSFEC_EC_CODE_VALUE in DD01L
res2 = c.call('BBP_RFC_READ_TABLE',
    QUERY_TABLE='DD01L',
    DELIMITER='|',
    OPTIONS=[{'TEXT': "DOMNAME = 'HRSFEC_EC_CODE_VALUE'"}]
)
for r in res2['DATA']:
    print("DD01L:", r['WA'])

c.close()

