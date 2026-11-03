import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check PA0001, PA0002, PA0008 for 70000017
for t in ['PA0001', 'PA0002', 'PA0008']:
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=t, DELIMITER='|',
               OPTIONS=[{'TEXT': "PERNR = '70000017'"}])
    print(f"--- {t} (count: {len(r['DATA'])}) ---")
    for row in r['DATA']:
        print(row['WA'])

c.close()

