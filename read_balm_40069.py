import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='BALM', DELIMITER='|',
           OPTIONS=[{'TEXT': "LOGNUMBER = '00000000000000040069'"}],
           FIELDS=[{'FIELDNAME': 'LOGNUMBER'}, {'FIELDNAME': 'MSGTY'},
                   {'FIELDNAME': 'MSGID'}, {'FIELDNAME': 'MSGNO'},
                   {'FIELDNAME': 'MSGV1'}, {'FIELDNAME': 'MSGV2'}])

print(f"Messages in 40069: {len(r['DATA'])}")
for d in r['DATA']:
    print(d['WA'].strip())

c.close()

