import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check classes related to IT0002
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOCLASS', DELIMITER='|',
           OPTIONS=[{'TEXT': "CLSNAME LIKE 'CL_HRPA%0002%'"}],
           FIELDS=[{'FIELDNAME': 'CLSNAME'}])
print("Classes CL_HRPA%0002%:")
for d in r['DATA']:
    print(d['WA'].strip())

# Check T582A for 0002
r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T582A', DELIMITER='|',
            OPTIONS=[{'TEXT': "INFTY = '0002'"}],
            FIELDS=[{'FIELDNAME': 'INFTY'}, {'FIELDNAME': 'DNAME'}, {'FIELDNAME': 'NOAP'}])
print("T582A 0002:", r2['DATA'])

c.close()

