import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Query BADI_IMPL / ENHBADIIMPL / SXC_ATTR / ENHSPOT
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ENHOBJ', DELIMITER='|',
           OPTIONS=[{'TEXT': "ENHNAME = 'ZHRSFEC_B_CE_CHANGE_IT0002'"}],
           FIELDS=[{'FIELDNAME': 'ENHNAME'}, {'FIELDNAME': 'OBJECT'}, {'FIELDNAME': 'OBJ_NAME'}])
print("ENHOBJ:", r['DATA'])

