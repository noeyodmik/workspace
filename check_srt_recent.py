import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

fields = [{'FIELDNAME': 'MSGID'}, {'FIELDNAME': 'TIMESTAMPL'}, {'FIELDNAME': 'LOCATION'},
          {'FIELDNAME': 'INTERFACE_NAME'}, {'FIELDNAME': 'OPERATION_NAME'}]

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SRT_MONLOG_DATA2',
           FIELDS=fields,
           ROWCOUNT=10)

for d in r.get('DATA', []):
    print("SRT:", d['WA'])

c.close()

