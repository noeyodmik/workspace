import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Search where message 001 of HRSFEC_CE_CONV is called
res = c.call('BBP_RFC_READ_TABLE',
    QUERY_TABLE='WBCROSSGT',
    DELIMITER='|',
    OPTIONS=[{'TEXT': "NAME LIKE '%HRSFEC_CE_CONV%' AND TYPE = 'ME'"}]
)

print("WBCROSSGT hits:", len(res['DATA']))
for r in res['DATA']:
    print(r['WA'])

c.close()

