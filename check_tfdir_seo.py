import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TFDIR', DELIMITER='|',
           OPTIONS=[{'TEXT': "FUNCNAME = 'SEO_IMPLEMENTG_CREATE'"}],
           FIELDS=[{'FIELDNAME': 'FUNCNAME'}, {'FIELDNAME': 'PNAME'}, {'FIELDNAME': 'INCLUDE'}])
print(r['DATA'])
c.close()

