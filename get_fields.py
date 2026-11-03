import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('DDIF_TABL_GET', NAME='T77SFEC_PTP_CONF')
for f in res.get('DD03P_TAB', []):
    print(f['FIELDNAME'], f['INTLEN'], f['DDTEXT'])

