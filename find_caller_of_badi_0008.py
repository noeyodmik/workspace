import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Query CROSS / WBCROSSGT for references to CALL_BADI_CHANGE_IT0008 or HRSFEC_B_CE_CHANGE_IT0008
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='WBCROSSGT', DELIMITER='|',
           OPTIONS=[{'TEXT': "NAME = 'CALL_BADI_CHANGE_IT0008'"}],
           FIELDS=[{'FIELDNAME': 'INCLUDE'}, {'FIELDNAME': 'NAME'}])
print("=== WBCROSSGT CALL_BADI_CHANGE_IT0008 ===")
for x in r['DATA']:
    print(x['WA'].strip())

r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='WBCROSSGT', DELIMITER='|',
            OPTIONS=[{'TEXT': "NAME = 'HRSFEC_B_CE_CHANGE_IT0008'"}],
            FIELDS=[{'FIELDNAME': 'INCLUDE'}, {'FIELDNAME': 'NAME'}])
print("=== WBCROSSGT HRSFEC_B_CE_CHANGE_IT0008 ===")
for x in r2['DATA']:
    print(x['WA'].strip())

