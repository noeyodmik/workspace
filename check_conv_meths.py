import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('BBP_RFC_READ_TABLE', 
             QUERY_TABLE='TMDIR', 
             OPTIONS=[{'TEXT': "CLASSNAME = 'CL_HRSFEC_API_CE_TYPE_CONV'"}],
             FIELDS=[{'FIELDNAME': 'METHODNAME'}])

for r in res['DATA']:
    print(r['WA'].strip())

c.close()

