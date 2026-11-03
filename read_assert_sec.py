import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

try:
    r = c.call('SEO_METHOD_GET_SOURCE', MTDKEY={'CLSNAME': 'CL_HRPA_INFOTYPE_CONTAINER', 'CPDNAME': 'ASSERT_SECONDARY_INFTY'})
    for l in r.get('SOURCE_EXPANDED', r.get('SOURCE', [])):
        print(l)
except Exception as e:
    print("SEO_METHOD_GET_SOURCE err:", e)

c.close()

