import io, sys, re
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 1. Read CL_HRSFEC_WT_PAYCOMP_MAPPING methods
for i in range(1, 11):
    suffix = f"{i:03X}"
    prog = f"CL_HRSFEC_WT_PAYCOMP_MAPPING==CM{suffix}"
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        print(f"=== {prog} ===")
        for idx, l in enumerate(lines, 1):
            print(f"{idx:03d}: {l}")
    except Exception:
        pass

# 2. Search CL_HRSFEC_EE_MDR_COMP_XX for HRSFEC_CE_CONV or HRSFEC_COMPENSAT
for i in range(1, 50):
    suffix = f"{i:03X}"
    prog = f"CL_HRSFEC_EE_MDR_COMP_XX======CM{suffix}"
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        txt = "\n".join(lines)
        if 'HRSFEC_CE_CONV' in txt or 'HRSFEC_COMPENSAT' in txt or 'PAY_COMPONENT' in txt or '091' in txt:
            print(f"=== {prog} (MATCH) ===")
            for idx, l in enumerate(lines, 1):
                print(f"{idx:03d}: {l}")
    except Exception:
        pass

# 3. Read all messages from Z_MCP_GET_REPLICATION_LOG starting at 08:40
r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_DATE_FROM='20261030', IV_DATE_TO='20261030', IV_MAX=50)
ms = r.get('ET_MESSAGES', [])
start = None
for i, m in enumerate(ms):
    mt = re.search(r'2026-10-30 (\d\d:\d\d)', m.get('MESSAGE') or '')
    if mt and mt.group(1) >= '08:40':
        start = i
        break
print("\n=== MESSAGES FROM 08:40 (start=", start, ") ===")
if start is not None:
    for i, m in enumerate(ms[max(0, start - 30):]):
        if m.get('ID') == 'HRSFEC_PTP' and m.get('NUMBER') == '102':
            print(f"[{i}] XML PAYLOAD: {(m.get('MESSAGE') or '')[:300]}...")
        else:
            print(f"[{i}] {m.get('TYPE')} {m.get('ID')} {m.get('NUMBER')} [{m.get('MESSAGE_V1')}|{m.get('MESSAGE_V2')}|{m.get('MESSAGE_V3')}|{m.get('MESSAGE_V4')}] -> {m.get('MESSAGE')}")

