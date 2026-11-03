import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T582S', DELIMITER='|',
           OPTIONS=[{'TEXT': "INFTY = '0539'"}],
           FIELDS=[{'FIELDNAME': 'SPRSL'}, {'FIELDNAME': 'INFTY'}, {'FIELDNAME': 'ITEXT'}])
print("T582S (0539):", r['DATA'])

