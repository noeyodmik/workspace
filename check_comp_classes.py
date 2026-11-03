import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOCLASS', DELIMITER='|',
           OPTIONS=[{'TEXT': "CLSNAME LIKE 'CL_HRSFEC%0008%'"}],
           FIELDS=[{'FIELDNAME': 'CLSNAME'}])
print("=== CL_HRSFEC%0008% ===")
for x in r['DATA']:
    print(x['WA'].strip())

r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOCLASS', DELIMITER='|',
            OPTIONS=[{'TEXT': "CLSNAME LIKE 'CL_HRSFEC%COMP%'"}],
            FIELDS=[{'FIELDNAME': 'CLSNAME'}])
print("=== CL_HRSFEC%COMP% ===")
for x in r2['DATA']:
    print(x['WA'].strip())

c.close()

