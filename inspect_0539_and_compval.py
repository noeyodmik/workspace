import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 1. Check T582ITVCLAS
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T582ITVCLAS', DELIMITER='|')
print("=== T582ITVCLAS (with 4th col or 0002/0539) ===")
for x in r['DATA']:
    wa = x['WA']
    cols = wa.split('|')
    if cols[1].strip() in ('0002', '0021', '0539', '0540') or cols[3].strip() != '':
        print(" ", wa)

# 2. Check CL_HRPA_INFOTYPE_CONTAINER methods for SECONDARY_RECORD-INFTY
for i in range(1, 25):
    prog = f"CL_HRPA_INFOTYPE_CONTAINER====CM{i:03X}"
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        txt = "\n".join(lines)
        if 'SECONDARY_RECORD' in txt:
            print(f"=== {prog} ===")
            for idx, l in enumerate(lines, 1):
                print(f"{idx:03d}: {l}")
    except Exception:
        pass

# 3. Check CL_HRSFEC_COMP_VALIDATION methods
tr = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TRDIR', DELIMITER='|',
            FIELDS=[{'FIELDNAME': 'NAME'}],
            OPTIONS=[{'TEXT': "NAME LIKE 'CL_HRSFEC%COMP%CM%'"}])
for x in tr['DATA']:
    prog = x['WA'].strip()
    if 'EE_MDR_COMP_XX' in prog:
        continue
    res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
    lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
    print(f"=== {prog} ===")
    for idx, l in enumerate(lines, 1):
        print(f"{idx:03d}: {l}")

# 4. Find which CM* in CL_HRSFEC_EE_MDR_COMP_XX has MAP_BASIC_PAY_CORE_FIELDS
for i in range(1, 55):
    prog = f"CL_HRSFEC_EE_MDR_COMP_XX======CM{i:03X}"
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        txt = "\n".join(lines)
        if 'METHOD MAP_BASIC_PAY_CORE_FIELDS' in txt.upper() or 'METHOD EXTRACT_PAY_COMP_WITH_AMOUNT' in txt.upper():
            print(f"=== {prog} ===")
            for idx, l in enumerate(lines, 1):
                print(f"{idx:03d}: {l}")
    except Exception:
        pass
