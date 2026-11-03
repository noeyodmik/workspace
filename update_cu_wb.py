import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

cu_name = 'ZHR_PY========================CU'
r_cu = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=cu_name)
orig_lines = [l['LINE'] for l in r_cu.get('SOURCE_EXTENDED', [])]

new_lines = orig_lines.copy()
if not any('IF_HRSFEC_CE_CHANGE_IT0008' in l for l in new_lines):
    new_lines.append('  INTERFACES IF_HRSFEC_CE_CHANGE_IT0008 .')

print("New CU lines:")
for l in new_lines:
    print(l)

# Try with Workbench task EA3K900013, or request EA3K900012
for tr in ['EA3K900013', 'EA3K900012']:
    try:
        print(f"Trying RPY_PROGRAM_UPDATE with {tr}...")
        c.call('RPY_PROGRAM_UPDATE',
               PROGRAM_NAME=cu_name,
               TRANSPORT_NUMBER=tr,
               SAVE_INACTIVE=' ',
               SOURCE_EXTENDED=[{'LINE': l} for l in new_lines])
        print(f"RPY_PROGRAM_UPDATE succeeded with {tr}!")
        break
    except Exception as e:
        print(f"Failed with {tr}:", e)

chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=cu_name)
chk_lines = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
print("Current CU lines after update:")
for l in chk_lines:
    print(l)

c.close()

