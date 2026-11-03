import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

try:
    r = c.call('AUTHORITY_CHECK_TCODE', TCODE='HRSFEC_PTP_EE_REPL')
    print("Authority check HRSFEC_PTP_EE_REPL:", r)
except Exception as e:
    print("Authority check failed:", e)

c.close()

