import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='CL_HRSFEC_BADI_CALL===========CCIMP')
for l in res.get('SOURCE_EXTENDED', [])[:30]:
    print(l['LINE'])

# Check methods of CL_HRSFEC_BADI_CALL using SEO_METHOD_GET_INCLUDE
# Or search D010INC
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='D010INC', DELIMITER='|',
           OPTIONS=[{'TEXT': "MASTER = 'CL_HRSFEC_BADI_CALL===========CP'"}])
for x in r['DATA']:
    print(x['WA'].strip())

