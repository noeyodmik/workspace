import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

try:
    res = c.call('ICM_SSL_PSE_CHANGED', GLOBAL=1)
    print("ICM_SSL_PSE_CHANGED result:", res)
except Exception as e:
    print("Error calling ICM_SSL_PSE_CHANGED:", e)

