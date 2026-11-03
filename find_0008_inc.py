import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'CL_HRSFEC_BADI_CALL' + '=' * (30 - len('CL_HRSFEC_BADI_CALL'))

for m in range(1, 35):
    inc = f"{pad}CM{m:03d}"
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        first_line = lines[0] if lines else ''
        if '0008' in first_line or any('0008' in l for l in lines[:5]):
            print(f"=== {inc}: {first_line} ===")
            for l in lines:
                print("  ", l)
    except Exception:
        pass

