import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Search for IF_HRSFEC_CE_CHANGE_IT0002
tr = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TRDIR', DELIMITER='|',
            FIELDS=[{'FIELDNAME': 'NAME'}],
            OPTIONS=[{'TEXT': "NAME LIKE 'CL_HRSFEC_CE_MAP_IT0002%'"}])

for x in tr['DATA']:
    prog = x['WA'].strip()
    try:
        res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=prog)
        lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
        txt = "\n".join(lines)
        if 'SECONDARY' in txt or '0539' in txt or 'BADI' in txt:
            print(f"=== {prog} ===")
            for idx, l in enumerate(lines, 1):
                if 'SECONDARY' in l or '0539' in l or 'CALL BADI' in l or 'PRELP' in l:
                    print(f"{idx:03d}: {l}")
    except Exception:
        pass

c.close()

