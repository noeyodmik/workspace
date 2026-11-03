import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check classes with ENH in SE24
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOCLASS', DELIMITER='|',
           OPTIONS=[{'TEXT': "CLSNAME LIKE 'CL_ENH_TOOL%'"}],
           FIELDS=[{'FIELDNAME': 'CLSNAME'}])
print("=== CL_ENH_TOOL* classes ===")
for x in r['DATA']:
    print(x['WA'].strip())

c.close()

