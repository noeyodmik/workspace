import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'CL_HRSFEC_EE_MDR_COMP_XX' + '=' * (30 - len('CL_HRSFEC_EE_MDR_COMP_XX'))

# In TMDIR, read METHODNAME
# We can just iterate CM001 to CM050
for m in range(1, 60):
    inc = f"{pad}CM{m:03d}"
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        if lines:
            line0 = lines[0].strip()
            if 'BASIC_PAY' in line0.upper():
                print(f"{inc}: {line0} (total {len(lines)} lines)")
    except Exception:
        pass

