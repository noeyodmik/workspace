import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('BBP_RFC_READ_TABLE', 
             QUERY_TABLE='RFCDES',
             OPTIONS=[{'TEXT': "RFCTYPE = 'G'"}],
             FIELDS=[{'FIELDNAME': 'RFCDEST'}, {'FIELDNAME': 'RFCTYPE'}])

print(f"Total Type G destinations: {len(res['DATA'])}")
for r in res['DATA']:
    wa = r['WA'].strip()
    if any(k in wa for k in ['100', 'PTP', 'ECP', 'HRSFEC', 'SF', 'EY', 'SD']):
        print(wa)

