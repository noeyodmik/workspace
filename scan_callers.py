import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

tr = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TRDIR', DELIMITER='|',
            FIELDS=[{'FIELDNAME': 'NAME'}],
            OPTIONS=[{'TEXT': "NAME LIKE 'CL_HRSFEC%CM%'"}])

matches = []
for x in tr['DATA']:
    prog = x['WA'].strip()
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        for idx, l in enumerate(lines, 1):
            if 'HRSFEC_B_CE_CHANGE_IT0002' in l and 'CL_HRSFEC_BADI_CALL' not in prog:
                print(f"Match in {prog}:{idx} -> {l}")
                matches.append(prog)
                break
    except Exception:
        pass

c.close()

