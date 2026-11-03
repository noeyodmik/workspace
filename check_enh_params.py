import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOSUBCO', DELIMITER='|',
            OPTIONS=[{'TEXT': "CLSNAME = 'CL_ENH_FACTORY' AND CMPNAME = 'CREATE_ENHANCEMENT'"}],
            FIELDS=[{'FIELDNAME': 'SCONAME'}, {'FIELDNAME': 'TYPTYPE'}, {'FIELDNAME': 'TYPE'}, {'FIELDNAME': 'PAROPTIONL'}])
print("=== Parameters of CL_ENH_FACTORY=>CREATE_ENHANCEMENT ===")
for x in r2['DATA']:
    print(x['WA'].strip())

c.close()
