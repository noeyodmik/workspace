import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

try:
    r = c.call('BAPI_BANK_CREATE',
               BANK_CTRY='KR',
               BANK_KEY='004',
               BANK_ADDRESS={'BANK_NAME': 'KB Kookmin Bank', 'CITY': 'Seoul'})
    print("BAPI_BANK_CREATE result:", r.get('RETURN'))
except Exception as e:
    print("BAPI_BANK_CREATE err:", e)

