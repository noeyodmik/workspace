import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TMDIR', DELIMITER='|',
           OPTIONS=[{'TEXT': "CLASSNAME = 'CL_ENH_TOOL_BADI_IMPL' AND "},
                    {'TEXT': "METHODNAME = 'ADD_IMPLEMENTATION'"}],
           FIELDS=[{'FIELDNAME': 'METHODINDX'}])
print("Index:", r['DATA'][0]['WA'].strip())

c.close()
