import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T591A', DELIMITER='|',
           OPTIONS=[{'TEXT': "INFTY = '0008'"}],
           FIELDS=[{'FIELDNAME': 'INFTY'}, {'FIELDNAME': 'SUBTY'}, {'FIELDNAME': 'STEXT'}])
print("T591A (0008):", [x['WA'] for x in r['DATA']])

