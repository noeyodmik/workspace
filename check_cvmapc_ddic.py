import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

fields = c.call('DDIF_TABL_GET', NAME='T77SFEC_CVMAPC')
for f in fields.get('DFIES_TAB', []):
    if 'EC_CODE' in f.get('FIELDNAME') or 'ERP_CODE' in f.get('FIELDNAME'):
        print(f['FIELDNAME'], f['DATATYPE'], f['LENG'], f['DOMNAME'], f['LOWERCASE'])

# Check domain definition of EC_CODE_VALUE
dom = c.call('DDIF_DOMA_GET', NAME='HRSFEC_EC_CODE_VALUE')
print("DOMA:", dom.get('DD01V_WA', {}).get('LOWERCASE'))

c.close()

