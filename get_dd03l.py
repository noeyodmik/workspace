import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('BBP_RFC_READ_TABLE', 
             QUERY_TABLE='DD03L', 
             OPTIONS=[{'TEXT': "TABNAME = 'T77SFEC_PTP_CONF'"}],
             FIELDS=[{'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'POSITION'}])

for r in sorted(res['DATA'], key=lambda x: int(x['WA'].split()[1])):
    print(r['WA'])

