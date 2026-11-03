import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

fields = [{'FIELDNAME': 'RFCDEST'}, {'FIELDNAME': 'RFCTYPE'}, {'FIELDNAME': 'RFCOPTIONS'}]

res = c.call('BBP_RFC_READ_TABLE', 
             QUERY_TABLE='RFCDES',
             OPTIONS=[{'TEXT': "RFCDEST = 'ECP_PTP_ODATA_100'"}],
             FIELDS=fields)

for r in res['DATA']:
    print("ECP_PTP_ODATA_100:", r['WA'])
