import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Find the include name for HRSFEC_B_CE_CHANGE_IT0008
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TMDIR', DELIMITER='|',
           OPTIONS=[{'TEXT': "CLASSNAME = 'CL_HRSFEC_BADI_CALL' AND METHODNAME LIKE '%0008%'"}],
           FIELDS=[{'FIELDNAME': 'METHODNAME'}])
print("=== TMDIR CL_HRSFEC_BADI_CALL ===")
for x in r['DATA']:
    print(x['WA'].strip())

# Also search all methods in CL_HRSFEC_BADI_CALL
r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TMDIR', DELIMITER='|',
            OPTIONS=[{'TEXT': "CLASSNAME = 'CL_HRSFEC_BADI_CALL'"}],
            FIELDS=[{'FIELDNAME': 'METHODNAME'}])
print("=== All methods ===")
for x in r2['DATA']:
    print(x['WA'].strip())

