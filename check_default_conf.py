import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

fields = [{'FIELDNAME': 'CONFIG_ID'}, 
          {'FIELDNAME': 'COUNTRY'}, 
          {'FIELDNAME': 'DESTINATION'}, 
          {'FIELDNAME': 'TARGET_SYSTEM'}]

res = c.call('BBP_RFC_READ_TABLE', 
             QUERY_TABLE='T77SFEC_PTP_CONF', 
             OPTIONS=[{'TEXT': "CONFIG_ID = 'DEFAULT'"}],
             FIELDS=fields)

for r in res['DATA']:
    print("DEFAULT:", r['WA'])
