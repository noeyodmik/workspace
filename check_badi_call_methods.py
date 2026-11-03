import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check methods of CL_HRSFEC_BADI_CALL
res = c.call('BBP_RFC_READ_TABLE',
    QUERY_TABLE='TMDIR',
    DELIMITER='|',
    OPTIONS=[{'TEXT': "CLASSNAME = 'CL_HRSFEC_BADI_CALL'"}]
)

for r in res['DATA']:
    print(r['WA'])

c.close()

