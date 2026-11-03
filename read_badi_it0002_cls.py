import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

base = 'HRSFEC_B_CE_CHANGE_IT0002'
for suffix in ('=====CP', '=====CU', '=====CM000', '=====CM001'):
    name = base + suffix
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=name)
        L = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        print(f"===== {name} ({len(L)} lines)")
        for i, l in enumerate(L[:120], 1):
            print(f"{i:3}: {l}")
    except Exception as e:
        print(f"===== {name} ERR: {str(e)[:120]}")
c.close()

