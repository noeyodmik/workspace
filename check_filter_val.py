import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L', DELIMITER='|',
           OPTIONS=[{'TEXT': "TABNAME = 'ENH_BADIIMPL_FILTER_VALUE' AND AS4LOCAL = 'A'"}],
           FIELDS=[{'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'ROLLNAME'}])
print("ENH_BADIIMPL_FILTER_VALUE fields:")
for x in r['DATA']:
    print(x['WA'].strip())

c.close()

