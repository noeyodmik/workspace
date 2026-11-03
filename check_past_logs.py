import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Query BALHDR for dates between 20261019 and 20261027
res = c.call('BBP_RFC_READ_TABLE', 
             QUERY_TABLE='BALHDR',
             OPTIONS=[
                 {'TEXT': "OBJECT = 'HRSFEC' AND "},
                 {'TEXT': "ALDATE >= '20261019' AND ALDATE <= '20261027'"}
             ],
             FIELDS=[{'FIELDNAME': 'LOGNUMBER'}, {'FIELDNAME': 'OBJECT'}, {'FIELDNAME': 'SUBOBJECT'}, {'FIELDNAME': 'ALDATE'}, {'FIELDNAME': 'ALTIME'}, {'FIELDNAME': 'EXTNUMBER'}])

print(f"Total logs found: {len(res['DATA'])}")
for r in res['DATA']:
    print(r['WA'])

