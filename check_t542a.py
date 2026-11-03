import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

f = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
           OPTIONS=[{'TEXT': "TABNAME = 'T542A' AND AS4LOCAL = 'A'"}],
           FIELDS=[{'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'KEYFLAG'}])
print('T542A fields:', [x['WA'].strip() for x in f['DATA']])

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T542A', DELIMITER='|',
           OPTIONS=[{'TEXT': "MOLGA = '41'"}])
print('T542A MOLGA=41 rows:', len(r['DATA']))
for x in r['DATA']:
    print(' ', x['WA'])

# any text table
try:
    t = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T542T', DELIMITER='|',
               OPTIONS=[{'TEXT': "MOLGA = '41' AND SPRSL = '3'"}])
    print('T542T texts:')
    for x in t['DATA']:
        print(' ', x['WA'])
except Exception as e:
    print('T542T err', e)

# which ERP values the customer mapping uses for CONTRACT_TYPE
m = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_CVMAPC', DELIMITER='|',
           OPTIONS=[{'TEXT': "EC_DATA_TYPE = 'CONTRACT_TYPE'"}])
for x in m['DATA']:
    print('CVMAPC:', x['WA'])

