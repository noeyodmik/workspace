import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L', DELIMITER='|',
           OPTIONS=[{'TEXT': "TABNAME = 'ENHNAME_TYPE' AND AS4LOCAL = 'A'"}],
           FIELDS=[{'FIELDNAME': 'FIELDNAME'}])
print("ENHNAME_TYPE fields:", [x['WA'].strip() for x in r['DATA']])

r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L', DELIMITER='|',
            OPTIONS=[{'TEXT': "TABNAME = 'ENHHEADER' AND AS4LOCAL = 'A'"}],
            FIELDS=[{'FIELDNAME': 'FIELDNAME'}])
print("ENHHEADER fields:", [x['WA'].strip() for x in r2['DATA']])

c.close()

