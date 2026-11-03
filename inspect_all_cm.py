import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'CL_HRSFEC_BADI_CALL' + '=' * (30 - len('CL_HRSFEC_BADI_CALL'))

# List of chars: 1-9, A-X
chars = [str(i) for i in range(1, 10)] + [chr(c) for c in range(ord('A'), ord('X')+1)]

for ch in chars:
    inc = f"{pad}CM00{ch}"
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        for l in lines:
            if 'METHOD' in l.upper() or 'GET BADI' in l.upper() or 'HRSFEC_B_' in l.upper():
                print(f"{inc}: {l}")
    except Exception:
        pass

