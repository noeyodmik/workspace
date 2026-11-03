import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('DDIF_FIELDINFO_GET', TABNAME='HRSFEC_D_REPSTAT')
fields = [(f['FIELDNAME'], f['INTLEN'], f['FIELDTEXT']) for f in res.get('DFIES_TAB', [])]
for f in fields:
    print(f)

c.close()

