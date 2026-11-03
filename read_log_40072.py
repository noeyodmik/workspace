import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Read BALM for 40072
fields = [{'FIELDNAME': 'LOGNUMBER'}, {'FIELDNAME': 'MSGNUMBER'}, {'FIELDNAME': 'MSGTY'},
          {'FIELDNAME': 'MSGID'}, {'FIELDNAME': 'MSGNO'}, {'FIELDNAME': 'MSGV1'}]
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='BALM',
           FIELDS=fields,
           OPTIONS=[{'TEXT': "LOGNUMBER = '00000000000000040072'"}])

for d in r.get('DATA', []):
    print("40072 MSG:", d['WA'])

# Also check 40060 and 40064 (which were also EMPLOYEE_PTP REPLICATION)
r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='BALM',
            FIELDS=fields,
            OPTIONS=[{'TEXT': "LOGNUMBER = '00000000000000040060'"}])

for d in r2.get('DATA', []):
    print("40060 MSG:", d['WA'])

c.close()

