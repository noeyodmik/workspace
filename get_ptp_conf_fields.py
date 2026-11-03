import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('DDIF_FIELDINFO_GET', TABNAME='T77SFEC_PTP_CONF')
fields = [(f['FIELDNAME'], f['INTLEN']) for f in res.get('DFIES_TAB', [])]
print(fields)

c.close()

