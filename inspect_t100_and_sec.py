import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# 1. Check T100 for HRSFEC_COMPENSAT 000 and CX_HRSFEC_COMPENSAT
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T100', DELIMITER='|',
           OPTIONS=[{'TEXT': "ARBGB = 'HRSFEC_COMPENSAT' AND MSGNR IN ('000', '001', '002', '003', '004', '005')"}])
print("=== T100 HRSFEC_COMPENSAT ===")
for x in r['DATA']:
    print(" ", x['WA'])

# 2. Read CX_HRSFEC_COMPENSAT================CI / CU
for prog in ['CX_HRSFEC_COMPENSAT===========CU', 'CL_HRPA_INFOTYPE_CONTAINER====CM010', 'CL_HRPA_INFOTYPE_CONTAINER====CM012', 'CL_HRPA_INFOTYPE_CONTAINER====CM013', 'CL_HRPA_INFOTYPE_CONTAINER====CM014']:
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        print(f"=== {prog} ===")
        for idx, l in enumerate(lines, 1):
            print(f"{idx:03d}: {l}")
    except Exception as e:
        print(prog, e)

# 3. Find where 0539 is referenced in CL_HRSFEC* or CL_HRPA*
tr = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TRDIR', DELIMITER='|',
            FIELDS=[{'FIELDNAME': 'NAME'}],
            OPTIONS=[{'TEXT': "NAME LIKE 'CL_HRSFEC%0002%' OR NAME LIKE 'CL_HRSFEC%KR%' OR NAME LIKE 'CL_HRSFEC%PERS%'"}])
for x in tr['DATA']:
    print("TRDIR:", x['WA'].strip())

