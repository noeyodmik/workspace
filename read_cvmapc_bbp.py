import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('BBP_RFC_READ_TABLE',
    QUERY_TABLE='T77SFEC_CVMAPC',
    DELIMITER='|',
    OPTIONS=[{'TEXT': "EC_DATA_TYPE = 'PAY_COMPONENT'"}]
)

print("Entries count:", len(res['DATA']))
for r in res['DATA']:
    print(r['WA'])

c.close()

