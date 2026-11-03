import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('SEO_CLASS_GET_INCLUDE_METH', CLSNAME='CL_HRPA_INFOTYPE_0002_KR')
for m in r.get('INCLUDES', []):
    print(m)

c.close()

