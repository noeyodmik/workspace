import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L', DELIMITER='|',
           OPTIONS=[{'TEXT': "TABNAME = 'PAD_SFEC_CE_PAYCOMP_RECURRING' AND FIELDNAME = 'CURRENCY_CODE'"}],
           FIELDS=[{'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'ROLLNAME'}, {'FIELDNAME': 'DATATYPE'}])
print("CURRENCY_CODE:", r['DATA'])

c.close()

