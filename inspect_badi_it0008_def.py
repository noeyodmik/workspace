import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check ENHBADI or BEXC for HRSFEC_B_CE_CHANGE_IT0008
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SXS_ATTR', DELIMITER='|',
           OPTIONS=[{'TEXT': "EXIT_NAME = 'HRSFEC_B_CE_CHANGE_IT0008'"}],
           FIELDS=[{'FIELDNAME': 'EXIT_NAME'}, {'FIELDNAME': 'DEF_TEXT'}])
print("SXS_ATTR:", r['DATA'])

# Check interface IF_HRSFEC_CE_CHANGE_IT0008
res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='IF_HRSFEC_CE_CHANGE_IT0008====IU')
for l in res.get('SOURCE_EXTENDED', []):
    print(l['LINE'])

