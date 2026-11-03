import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

try:
    res = c.call('ICM_READ_TRC_FILE', ICM_LAST_N_LINES=100)
    for line in res.get('LINES', []):
        print(line.get('LINES', ''))
except Exception as e:
    print("Error calling ICM_READ_TRC_FILE:", e)

