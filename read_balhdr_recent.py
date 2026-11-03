import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='BALHDR', DELIMITER='|',
           OPTIONS=[{'TEXT': "OBJECT = 'HRSFEC' AND ALDATE >= '20261030'"}],
           FIELDS=[{'FIELDNAME': 'LOGNUMBER'}, {'FIELDNAME': 'ALDATE'}, {'FIELDNAME': 'ALTIME'},
                   {'FIELDNAME': 'ALUSER'}, {'FIELDNAME': 'EXTNUMBER'},
                   {'FIELDNAME': 'MSG_CNT_AL'}, {'FIELDNAME': 'MSG_CNT_E'}, {'FIELDNAME': 'MSG_CNT_W'}])
for x in r['DATA'][-10:]:
    print(x['WA'].strip())

c.close()

