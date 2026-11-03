import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'CL_HRSFEC_EE_MDR_COMP_XX' + '=' * (30 - len('CL_HRSFEC_EE_MDR_COMP_XX'))

# All possible CM includes
chars = [f"{i:02X}" for i in range(1, 100)] + [f"{i:03d}" for i in range(1, 100)]
seen = set()

for code in chars:
    inc = f"{pad}CM0{code[-2:]}"
    if inc in seen:
        continue
    seen.add(inc)
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        for idx, l in enumerate(lines):
            if 'CALL_BADI_CHANGE_IT0008' in l:
                print(f"{inc} L{idx+1}: {l}")
    except Exception:
        pass

