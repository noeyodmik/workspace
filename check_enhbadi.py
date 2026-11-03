import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Search for BAdI definition where INTER_NAME = 'IF_HRSFEC_CE_CHANGE_IT0008'
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ENHBADI', DELIMITER='|',
           OPTIONS=[{'TEXT': "INTERFACE = 'IF_HRSFEC_CE_CHANGE_IT0008'"}],
           FIELDS=[{'FIELDNAME': 'BADI_NAME'}, {'FIELDNAME': 'SPOT_NAME'}, {'FIELDNAME': 'INTERFACE'}])
print("=== ENHBADI ===")
for x in r['DATA']:
    print(x['WA'].strip())

# Also search all ENHBADI for HRSFEC
r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ENHBADI', DELIMITER='|',
            OPTIONS=[{'TEXT': "BADI_NAME LIKE 'HRSFEC%'"}],
            FIELDS=[{'FIELDNAME': 'BADI_NAME'}, {'FIELDNAME': 'SPOT_NAME'}, {'FIELDNAME': 'INTERFACE'}])
print("=== All HRSFEC BAdIs in ENHBADI ===")
for x in r2['DATA']:
    print(x['WA'].strip())

