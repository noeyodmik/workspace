import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L', DELIMITER='|',
           OPTIONS=[{'TEXT': "TABNAME = 'ENHBDEX' AND AS4LOCAL = 'A'"}],
           FIELDS=[{'FIELDNAME': 'FIELDNAME'}])
print("ENHBDEX fields:", [x['WA'].strip() for x in r['DATA']])

r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ENHBDEX', DELIMITER='|',
            OPTIONS=[{'TEXT': "ENHNAME LIKE 'ZHRSFEC%'"}])
print("ENHBDEX entries for ZHRSFEC:")
for x in r2['DATA']:
    print(x['WA'].strip())

c.close()

