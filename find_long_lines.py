import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
lines = [l['LINE'] for l in r.get('SOURCE_EXTENDED', [])]
long_lines = [(i+1, len(l), l) for i, l in enumerate(lines) if len(l) > 72]
print(f"Lines longer than 72 in LZMCPU11: {len(long_lines)}")
for idx, l_len, l in long_lines:
    print(f"Line {idx} ({l_len}): {l}")

c.close()

