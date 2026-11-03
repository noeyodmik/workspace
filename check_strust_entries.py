import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

for tbl in ['SSFARGS', 'SSFAPPLIC', 'STRUSTINSTANCE_S']:
    try:
        res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=tbl, ROWCOUNT=10)
        print(f"=== {tbl} ===")
        for r in res['DATA']:
            print(" ", r['WA'].strip())
    except Exception as e:
        print(f"=== {tbl} err ===", e)
