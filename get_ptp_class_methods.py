import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('SEO_CLASS_GET_DETAIL', CLSNAME='CL_HRSFEC_PTP_EE_REPLICATION')
methods = [m['CMPNAME'] for m in r.get('METHODS', [])]
print("Methods of CL_HRSFEC_PTP_EE_REPLICATION:", methods)

c.close()

