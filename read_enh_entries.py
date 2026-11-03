import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ENHNAME_TYPE', DELIMITER='|',
           OPTIONS=[{'TEXT': "ENHNAME LIKE 'ZHRSFEC%'"}],
           FIELDS=[{'FIELDNAME': 'ENHNAME'}, {'FIELDNAME': 'ENHTOOLTYPE'}])
print("ENHNAME_TYPE entries:")
for x in r['DATA']:
    print(x['WA'].strip())

r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ENHHEADER', DELIMITER='|',
            OPTIONS=[{'TEXT': "ENHNAME LIKE 'ZHRSFEC%'"}],
            FIELDS=[{'FIELDNAME': 'ENHNAME'}, {'FIELDNAME': 'ENHTOOLTYPE'}, {'FIELDNAME': 'TYPE'}, {'FIELDNAME': 'STATE'}])
print("ENHHEADER entries:")
for x in r2['DATA']:
    print(x['WA'].strip())

c.close()

