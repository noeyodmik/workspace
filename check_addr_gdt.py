import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 1. Check CL_HRSFEC_ADDR_MAPPING_KR and CL_HRSFEC_GDT_CODE_MAPPING
for cls in ['CL_HRSFEC_ADDR_MAPPING_KR', 'CL_HRSFEC_ADDR_MAPPING_XX', 'CL_HRSFEC_GDT_CODE_MAPPING']:
    pad = cls + '=' * (30 - len(cls))
    for i in range(1, 15):
        inc = pad + 'CM%03d' % i
        try:
            res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc)
            print(f"=== {inc} ===")
            for idx, l in enumerate(res.get('SOURCE_EXTENDED', [])):
                print(f"{idx:03d}: {l['LINE']}")
        except Exception:
            continue

