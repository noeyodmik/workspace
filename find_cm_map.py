import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'CL_HRSFEC_EE_MDR_COMP_XX' + '=' * (30 - len('CL_HRSFEC_EE_MDR_COMP_XX'))

for m in range(1, 115):
    inc = f"{pad}CM{m:03d}"
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        if lines:
            line0 = lines[0].strip()
            if any(k in line0.upper() for k in ['PROCESS_BASIC_PAY', 'MAP_BASIC_PAY', 'PROCESS_COMPENSATION', 'CHANGE_IT0008']):
                print(f"{inc}: {line0} ({len(lines)} lines)")
    except Exception:
        pass

