import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

f = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
           OPTIONS=[{'TEXT': "TABNAME = 'T77SFEC_CVMAPC' AND AS4LOCAL = 'A'"}],
           FIELDS=[{'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'KEYFLAG'}])
print('FIELDS:', [x['WA'].strip() for x in f['DATA']])

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_CVMAPC', DELIMITER='|',
           OPTIONS=[{'TEXT': "EC_DATA_TYPE = 'CONTRACT_TYPE'"}])
print('FLDS:', [x['FIELDNAME'] for x in r['FIELDS']])
for x in r['DATA']:
    print(x['WA'])

r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_CVMAPS', DELIMITER='|',
            OPTIONS=[{'TEXT': "EC_DATA_TYPE = 'CONTRACT_TYPE'"}])
print('SAP-delivered mapping rows:', len(r2['DATA']))
for x in r2['DATA'][:10]:
    print(x['WA'])


