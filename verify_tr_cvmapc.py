import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

k = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='E071K', DELIMITER='|',
           OPTIONS=[{'TEXT': "OBJNAME = 'T77SFEC_CVMAPC'"}],
           FIELDS=[{'FIELDNAME': 'TRKORR'}, {'FIELDNAME': 'OBJNAME'}, {'FIELDNAME': 'TABKEY'}])
print('TR key entries for T77SFEC_CVMAPC:')
for x in k['DATA']:
    print(' ', x['WA'])

