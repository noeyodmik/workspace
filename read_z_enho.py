import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Query TADIR for classes in package ZHR_PY
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TADIR', DELIMITER='|',
           OPTIONS=[{'TEXT': "DEVCLASS = 'ZHR_PY' AND OBJECT = 'CLAS'"}],
           FIELDS=[{'FIELDNAME': 'OBJ_NAME'}])
print("=== CLAS in ZHR_PY ===")
for x in r['DATA']:
    print(x['WA'].strip())

