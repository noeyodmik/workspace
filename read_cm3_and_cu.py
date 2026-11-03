import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r_cm3 = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='ZHR_PY========================CM003')
print('--- CM003 lines ---')
for l in r_cm3.get('SOURCE_EXTENDED', []):
    print(l['LINE'])

r_cu = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='ZHR_PY========================CU')
print('--- CU lines ---')
for l in r_cu.get('SOURCE_EXTENDED', []):
    print(l['LINE'])

c.close()

