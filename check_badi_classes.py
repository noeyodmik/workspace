import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Query SEOMETAREL for interface implementations
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOMETAREL', DELIMITER='|',
           OPTIONS=[{'TEXT': "REFCLSNAME LIKE 'IF_HRSFEC_CE_CHANGE%'"}],
           FIELDS=[{'FIELDNAME': 'CLSNAME'}, {'FIELDNAME': 'REFCLSNAME'}])
print("=== Implementing classes of IF_HRSFEC_CE_CHANGE* ===")
for x in r['DATA']:
    print(x['WA'].strip())

