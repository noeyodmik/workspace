import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TMDIR', DELIMITER='|',
           OPTIONS=[{'TEXT': "CLASSNAME = 'ZHR_PY'"}],
           FIELDS=[{'FIELDNAME': 'METHODNAME'}, {'FIELDNAME': 'METHODINDX'}])
for x in r['DATA']:
    parts = x['WA'].split('|')
    print(parts[0].strip(), parts[1].strip())

