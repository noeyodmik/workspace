import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check DD03L for ENHSPOTHEADER
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
           OPTIONS=[{'TEXT': "TABNAME = 'ENHSPOTHEADER' AND AS4LOCAL = 'A'"}],
           FIELDS=[{'FIELDNAME': 'FIELDNAME'}])
print('ENHSPOTHEADER fields:', [x['WA'].strip() for x in r['DATA']])

# Check DD03L for ENHHEADER
r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
            OPTIONS=[{'TEXT': "TABNAME = 'ENHHEADER' AND AS4LOCAL = 'A'"}],
            FIELDS=[{'FIELDNAME': 'FIELDNAME'}])
print('ENHHEADER fields:', [x['WA'].strip() for x in r2['DATA']])

