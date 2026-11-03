import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'CL_HRSFEC_EE_MDR_COMP_XX' + '=' * (30 - len('CL_HRSFEC_EE_MDR_COMP_XX'))

for m in range(1, 120):
    inc = f"{pad}CM{m:03d}"
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        if lines and lines[0].strip().startswith('METHOD PROCESS_COMPENSATION.'):
            print(f"FOUND: {inc} has PROCESS_COMPENSATION ({len(lines)} lines)")
            for i, l in enumerate(lines[:50]):
                print(f"  {i+1}: {l}")
            break
    except Exception:
        pass

