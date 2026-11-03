import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check parameters of RZL_READ_DIR_LOCAL
res = c.call('BBP_RFC_READ_TABLE', 
             QUERY_TABLE='FUPARAREF', 
             OPTIONS=[{'TEXT': "FUNCNAME = 'RZL_READ_DIR_LOCAL'"}], 
             FIELDS=[{'FIELDNAME': 'PARAMETER'}, {'FIELDNAME': 'PARAMTYPE'}, {'FIELDNAME': 'STRUCTURE'}])
for r in res['DATA']:
    print(r['WA'].strip())

