import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOMETAREL', DELIMITER='|',
           OPTIONS=[{'TEXT': "REFCLSNAME = 'CL_HRSFEC_EE_MDR_COMP_XX'"}],
           FIELDS=[{'FIELDNAME': 'CLSNAME'}, {'FIELDNAME': 'RELTYPE'}])
print("Subclasses of CL_HRSFEC_EE_MDR_COMP_XX:", [x['WA'] for x in r['DATA']])

