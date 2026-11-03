import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Read CU
r_cu = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='ZHR_PY========================CU')
print('--- CU lines ---')
for l in r_cu.get('SOURCE_EXTENDED', []):
    print(l['LINE'])

# Read CM001
r_cm1 = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='ZHR_PY========================CM001')
print('--- CM001 lines ---')
for l in r_cm1.get('SOURCE_EXTENDED', []):
    print(l['LINE'])

# Read CM002
r_cm2 = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='ZHR_PY========================CM002')
print('--- CM002 lines ---')
for l in r_cm2.get('SOURCE_EXTENDED', []):
    print(l['LINE'])

c.close()
