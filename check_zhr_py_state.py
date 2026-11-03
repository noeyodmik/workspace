import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOCLASS', DELIMITER='|',
           OPTIONS=[{'TEXT': "CLSNAME = 'ZHR_PY'"}],
           FIELDS=[{'FIELDNAME': 'CLSNAME'}, {'FIELDNAME': 'STATE'}])
for x in r['DATA']:
    print("SEOCLASS state:", x['WA'].strip())

c.close()

