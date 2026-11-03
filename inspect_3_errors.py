import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 1. Check T582ITVCLAS and T582ITVCHCK for 0002 / 0539
for tab in ['T582ITVCLAS', 'T582ITVCHCK']:
    try:
        r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=tab, DELIMITER='|',
                   OPTIONS=[{'TEXT': "INFTY IN ('0002', '0539')"}])
        print(f"=== {tab} ===")
        for x in r['DATA']:
            print(" ", x['WA'])
    except Exception as e:
        print(tab, e)

# 2. Check CL_HRSFEC_EE_MDR_COMP_XX includes where MAP_BASIC_PAY_CORE_FIELDS and GO_COMP_VALIDATION are defined
for prog in ['CL_HRSFEC_EE_MDR_COMP_XX======CI', 'CL_HRSFEC_EE_MDR_COMP_XX======CCDEF', 'CL_HRSFEC_EE_MDR_COMP_XX======CCIMP']:
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        print(f"=== {prog} ===")
        for idx, l in enumerate(lines, 1):
            print(f"{idx:03d}: {l}")
    except Exception as e:
        print(prog, e)

# 3. Search all CM* of CL_HRSFEC_EE_MDR_COMP_XX for MAP_BASIC_PAY_CORE_FIELDS or EXTRACT_PAY_COMP_WITH_AMOUNT
for i in range(1, 55):
    suffix = f"{i:03X}"
    prog = f"CL_HRSFEC_EE_MDR_COMP_XX======CM{suffix}"
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        txt = "\n".join(lines[:5])
        if 'MAP_BASIC_PAY_CORE_FIELDS' in txt or 'EXTRACT_PAY_COMP_WITH_AMOUNT' in txt or 'CHECK_PAY_FREQUENCY' in txt:
            print(f"=== {prog} ===")
            for idx, l in enumerate(lines, 1):
                print(f"{idx:03d}: {l}")
    except Exception:
        pass
