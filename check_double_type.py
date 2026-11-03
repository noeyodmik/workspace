import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD04L', DELIMITER='|',
           OPTIONS=[{'TEXT': "ROLLNAME = 'PAD_SFEC_DOUBLE_VALUE'"}],
           FIELDS=[{'FIELDNAME': 'ROLLNAME'}, {'FIELDNAME': 'DOMNAME'}, {'FIELDNAME': 'DATATYPE'}, {'FIELDNAME': 'LENG'}, {'FIELDNAME': 'DECIMALS'}])
print("DD04L:", r['DATA'])

c.close()

