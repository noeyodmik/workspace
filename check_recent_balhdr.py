import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

fields = [{'FIELDNAME': 'LOGNUMBER'}, {'FIELDNAME': 'OBJECT'}, {'FIELDNAME': 'SUBOBJECT'},
          {'FIELDNAME': 'EXTNUMBER'}, {'FIELDNAME': 'ALDATE'}, {'FIELDNAME': 'ALTIME'}]
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='BALHDR',
           FIELDS=fields,
           OPTIONS=[{'TEXT': "LOGNUMBER >= '00000000000000040055'"}])

for d in r.get('DATA', []):
    print("LOG:", d['WA'])

c.close()

