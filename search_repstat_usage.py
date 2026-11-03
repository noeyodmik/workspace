import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Search where HRSFEC_D_REPSTAT is used
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='WBCROSSGT',
           OPTIONS=[{'TEXT': "NAME = 'HRSFEC_D_REPSTAT' AND OTYPE = 'TY'"}])
for d in r.get('DATA', []):
    print("WBCROSSGT:", d['WA'])

c.close()

