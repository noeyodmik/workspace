import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

logno = sys.argv[1] if len(sys.argv) > 1 else '00000000000000040072'
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='BALM', DELIMITER='|',
           OPTIONS=[{'TEXT': f"LOGNUMBER = '{logno}'"}],
           FIELDS=[{'FIELDNAME': 'LOGNUMBER'}, {'FIELDNAME': 'MSGNUMBER'}, {'FIELDNAME': 'MSGTY'},
                   {'FIELDNAME': 'MSGID'}, {'FIELDNAME': 'MSGNO'}, {'FIELDNAME': 'MSGV1'}, {'FIELDNAME': 'MSGV2'}, {'FIELDNAME': 'MSGV3'}])
for x in r['DATA']:
    print(x['WA'].strip())

c.close()

