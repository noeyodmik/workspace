import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 1. Read CL_HRPA_INFOTYPE_CONTAINER method SECONDARY_INFTY and CL_HRSFEC_EE_MDR_PERS*
for i in range(1, 25):
    prog = f"CL_HRPA_INFOTYPE_CONTAINER====CM{i:03X}"
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        if lines and 'SECONDARY_INFTY' in lines[0]:
            print(f"=== {prog} ===")
            for idx, l in enumerate(lines, 1):
                print(f"{idx:03d}: {l}")
    except Exception:
        pass

tr = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TRDIR', DELIMITER='|',
            FIELDS=[{'FIELDNAME': 'NAME'}],
            OPTIONS=[{'TEXT': "NAME LIKE 'CL_HRSFEC%PERS%CM%'"}])
for x in tr['DATA']:
    prog = x['WA'].strip()
    res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
    lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
    txt = "\n".join(lines)
    if '0539' in txt or 'SECONDARY' in txt or 'ITBLD' in txt or 'VIEKN' in txt:
        print(f"=== {prog} ===")
        for idx, l in enumerate(lines, 1):
            print(f"{idx:03d}: {l}")

# 2. Check T549A, T549R, T77SFEC_CVMAPC/S for PAY_FREQUENCY and PAYROLL_GROUP
for tab, opt in [
    ('T549A', "ABKRS IN ('01', 'K0', 'KR', '41')"),
    ('T549R', "PERMO <> ''"),
    ('T77SFEC_CVMAPC', "EC_DATA_TYPE LIKE '%FREQ%' OR EC_DATA_TYPE LIKE '%PAY%'"),
    ('T77SFEC_CVMAPS', "EC_DATA_TYPE LIKE '%FREQ%'"),
    ('T77SFEC_WT_PROC', "MOLGA = '41'"),
    ('HRSFEC_D_REPSTAT', "EMPLOYEE_ID_EXT IN ('70000017', '70000019')"),
]:
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=tab, DELIMITER='|', OPTIONS=[{'TEXT': opt}])
    print(f"=== {tab} ===")
    for x in r['DATA']:
        print(" ", x['WA'])

