import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOCLASS',
           OPTIONS=[{'TEXT': "CLSNAME LIKE 'CL_HRSFEC%COMP%' OR"},
                    {'TEXT': "CLSNAME LIKE 'CL_HRSFEC%0008%' OR"},
                    {'TEXT': "CLSNAME LIKE 'CL_HRSFEC%PAY%'"}],
           FIELDS=[{'FIELDNAME': 'CLSNAME'}])
print('COMP classes:', [x['WA'].strip() for x in r['DATA']])

