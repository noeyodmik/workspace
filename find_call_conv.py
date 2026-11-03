import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

for i in range(1, 60):
    prog = f"CL_HRSFEC_EE_MDR_COMP_XX======CM{i:03X}"
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        txt = "\n".join(lines)
        if 'GC_FLD_PAYCOMP_RECURRING-PAY_COMPONENT' in txt or 'pay_component' in txt.lower():
            for idx, l in enumerate(lines, 1):
                if 'CONVERT_STRING' in l or 'GC_FLD_PAYCOMP_RECURRING' in l:
                    print(f"{prog}:{idx:03d} {l}")
    except Exception:
        pass

