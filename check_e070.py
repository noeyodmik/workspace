import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='E070', DELIMITER='|',
           OPTIONS=[{'TEXT': "TRKORR = 'EA3K900019' OR TRKORR = 'EA3K900020'"}],
           FIELDS=[{'FIELDNAME': 'TRKORR'}, {'FIELDNAME': 'TRFUNCTION'}, {'FIELDNAME': 'TRSTATUS'}, {'FIELDNAME': 'KORRDEV'}])
for x in r['DATA']:
    print(x['WA'].strip())

c.close()

