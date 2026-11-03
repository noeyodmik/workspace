import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

fields = [{'FIELDNAME': 'RFCDEST'}, {'FIELDNAME': 'RFCOPTIONS'}]

for dest in ['100_SD', '100_EY', 'ECP_PTP_SOAP_100', 'ECP_PTP_ODATA_100']:
    res = c.call('BBP_RFC_READ_TABLE', 
                 QUERY_TABLE='RFCDES',
                 OPTIONS=[{'TEXT': f"RFCDEST = '{dest}'"}],
                 FIELDS=fields)
    for r in res['DATA']:
        print(f"[{dest}]:", r['WA'])

