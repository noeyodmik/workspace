import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('SSFP_GET_PSEINFO', APPLIC='100_EY')
print("100_EY PSE INFO:")
print("Subject:", res.get('SUBJECT'))

res_sd = c.call('SSFP_GET_PSEINFO', APPLIC='100_SD')
print("100_SD PSE INFO:")
print("Subject:", res_sd.get('SUBJECT'))

