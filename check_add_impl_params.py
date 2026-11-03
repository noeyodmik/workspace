import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOPARAM', DELIMITER='|',
           OPTIONS=[{'TEXT': "CLSNAME = 'CL_ENH_TOOL_BADI_IMPL' AND CMPNAME = 'ADD_IMPLEMENTATION'"}],
           FIELDS=[{'FIELDNAME': 'SCONAME'}, {'FIELDNAME': 'PAROPTIONL'}, {'FIELDNAME': 'PARPASSTYP'}, {'FIELDNAME': 'TYPTYPE'}, {'FIELDNAME': 'TYPE'}])
for x in r['DATA']:
    print(x['WA'].strip())

r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOPARAM', DELIMITER='|',
            OPTIONS=[{'TEXT': "CLSNAME = 'CL_ENH_TOOL_BADI_IMPL' AND CMPNAME = 'SET_SPOT_NAME'"}],
            FIELDS=[{'FIELDNAME': 'SCONAME'}, {'FIELDNAME': 'TYPE'}])
for x in r2['DATA']:
    print("SET_SPOT_NAME:", x['WA'].strip())

c.close()

