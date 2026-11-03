import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='BALHDR', DELIMITER='|',
           OPTIONS=[{'TEXT': "OBJECT = 'HRSFEC' AND ALDATE = '20261103'"}],
           FIELDS=[{'FIELDNAME': 'LOGNUMBER'}, {'FIELDNAME': 'SUBOBJECT'}, {'FIELDNAME': 'ALTIME'}, {'FIELDNAME': 'EXTNUMBER'}, {'FIELDNAME': 'MSG_CNT_AL'}, {'FIELDNAME': 'MSG_CNT_E'}])
print(f"Total logs today: {len(r['DATA'])}")
for x in r['DATA']:
    print(x['WA'].strip())

