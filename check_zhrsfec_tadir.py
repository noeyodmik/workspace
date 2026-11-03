import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TADIR', DELIMITER='|',
           OPTIONS=[{'TEXT': "OBJ_NAME LIKE 'ZHRSFEC%'"}],
           FIELDS=[{'FIELDNAME': 'PGMID'}, {'FIELDNAME': 'OBJECT'}, {'FIELDNAME': 'OBJ_NAME'}, {'FIELDNAME': 'DEVCLASS'}])
for x in r['DATA']:
    print(x['WA'].strip())

