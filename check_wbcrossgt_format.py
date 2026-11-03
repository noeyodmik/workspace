import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='WBCROSSGT', DELIMITER='|',
           OPTIONS=[{'TEXT': "INCLUDE LIKE 'CL_HRSFEC_EE_MDR_COMP_XX%' AND OTYPE = 'ME'"}],
           FIELDS=[{'FIELDNAME': 'INCLUDE'}, {'FIELDNAME': 'NAME'}])
print("WBCROSSGT count:", len(r['DATA']))
for x in r['DATA'][:20]:
    print(x['WA'].strip())

