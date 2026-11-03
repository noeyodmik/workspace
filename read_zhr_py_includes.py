import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

pad = 'ZHR_PY' + '=' * (30 - len('ZHR_PY')) + 'CP'

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='D010INC', DELIMITER='|',
           OPTIONS=[{'TEXT': f"MASTER = '{pad}'"}],
           FIELDS=[{'FIELDNAME': 'INCLUDE'}])

print("Total includes in ZHR_PY:", len(r['DATA']))
for x in r['DATA']:
    print(x['WA'].strip())

c.close()

