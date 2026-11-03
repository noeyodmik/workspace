import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# ?명꽣?섏씠??IF_HRSFEC_CE_CHANGE_IT0008 ??硫붿꽌???쒓렇?덉쿂 (?쎄린 ?꾩슜)
for name in ('IF_HRSFEC_CE_CHANGE_IT0008====IU', 'IF_HRSFEC_CE_CHANGE_IT0008====IP'):
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=name)
        L = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        print(f"===== {name} ({len(L)} lines)")
        for i, l in enumerate(L[:80], 1):
            print(f"{i:3}: {l}")
        if len(L) > 5:
            break
    except Exception as e:
        print(f"===== {name} ERR: {str(e)[:100]}")
c.close()

