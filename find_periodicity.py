import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'CL_HRSFEC_EE_MDR_COMP_XX' + '=' * (30 - len('CL_HRSFEC_EE_MDR_COMP_XX'))

for m in range(1, 25):
    inc = f"{pad}CM{m:03d}"
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        for idx, line in enumerate(lines):
            if 'CHECK_RECURR_PAYR_PERIODICITY' in line.upper() or 'CONVERT_STRING_C' in line.upper() or 'COMP_VALIDATION' in line.upper():
                print(f"{inc} L{idx+1}: {line}")
    except Exception:
        pass

