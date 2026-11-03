import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TRDIR', DELIMITER='|',
           OPTIONS=[{'TEXT': "NAME LIKE 'RP_HRSFEC%' AND SUBC = '1'"}],
           FIELDS=[{'FIELDNAME': 'NAME'}])
print("Replication reports:")
for d in r['DATA']:
    print(d['WA'].strip())

c.close()

