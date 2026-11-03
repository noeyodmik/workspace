import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Search D010INC for programs containing CHANGE_IT0008
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='WBCROSSGT', DELIMITER='|',
           OPTIONS=[{'TEXT': "NAME LIKE '%CHANGE_IT0008%'"}],
           FIELDS=[{'FIELDNAME': 'INCLUDE'}, {'FIELDNAME': 'NAME'}])
print("=== WBCROSSGT NAME LIKE %CHANGE_IT0008% ===")
for x in r['DATA']:
    print(x['WA'].strip())

