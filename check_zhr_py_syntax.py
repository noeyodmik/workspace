import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check syntax of program ZHR_PY (class pool: ZHR_PY========================CP)
# Use RFC_CHECK_PROGRAM or CHECK_SYNTAX if available, or write a syntax check check
try:
    res = c.call('RFC_CHECK_PROGRAM', PROGRAM='ZHR_PY========================CP')
    print("RFC_CHECK_PROGRAM:", res)
except Exception as e:
    print("RFC_CHECK_PROGRAM error:", e)

# Also check RPY_PROGRAM_READ for ZHR_PY
res2 = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='ZHR_PY========================CP')
print("ZHR_PY CP lines:", len(res2.get('SOURCE_EXTENDED', [])))

c.close()

