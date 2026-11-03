import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Search BADI_DEFINITION
try:
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='BADI_DEFINITION', DELIMITER='|',
               OPTIONS=[{'TEXT': "BADI_NAME LIKE 'HRSFEC%'"}])
    print("=== BADI_DEFINITION ===")
    for x in r['DATA']:
        print(x['WA'])
except Exception as e:
    print("BADI_DEFINITION err:", e)

# Search ENHHEADER
try:
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ENHHEADER', DELIMITER='|',
               OPTIONS=[{'TEXT': "ENHNAME LIKE 'HRSFEC%'"}])
    print("=== ENHHEADER ===")
    for x in r['DATA'][:20]:
        print(x['WA'])
except Exception as e:
    print("ENHHEADER err:", e)
