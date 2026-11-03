import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# In TMDIR, read CLASSNAME, METHODNAME, INCPROG
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TMDIR', DELIMITER='|',
           OPTIONS=[{'TEXT': "CLASSNAME = 'CL_HRSFEC_BADI_CALL' AND METHODNAME LIKE '%0008%'"}],
           FIELDS=[{'FIELDNAME': 'CLASSNAME'}, {'FIELDNAME': 'METHODNAME'}, {'FIELDNAME': 'INCPROG'}])
for x in r['DATA']:
    print(x['WA'].strip())

