import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

with open(r"c:\Users\sapin\Desktop\Workspace\LZMCPU11_BACKUP.abap", "r", encoding="utf-8") as f:
    backup_lines = f.read().splitlines()

print(f"Backup line count: {len(backup_lines)}")
c.call('RPY_INCLUDE_UPDATE',
       INCLUDE_NAME='LZMCPU11',
       TRANSPORT_NUMBER='EA3K900019',
       SAVE_INACTIVE=' ',
       SOURCE_EXTENDED=[{'LINE': l} for l in backup_lines])

chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
cur_lines = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
print(f"Current lines: {len(cur_lines)}")
print("Matches backup exactly:", cur_lines == backup_lines)

c.close()

