import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ENHSPOTHEADER', DELIMITER='|',
           OPTIONS=[{'TEXT': "ENHSPOT = 'HRSFEC_CE_CHANGE_IT0008'"}],
           FIELDS=[{'FIELDNAME': 'ENHSPOT'}, {'FIELDNAME': 'VERSION'}, {'FIELDNAME': 'TOOL'}])
print("ENHSPOTHEADER for IT0008:")
for x in r['DATA']:
    print(x['WA'].strip())

r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ENHNAME_TYPE', DELIMITER='|',
            OPTIONS=[{'TEXT': "ENHNAME LIKE 'ZHRSFEC%'"}],
            FIELDS=[{'FIELDNAME': 'ENHNAME'}, {'FIELDNAME': 'ENHTYPE'}])
print("ENHNAME_TYPE for ZHRSFEC:")
for x in r2['DATA']:
    print(x['WA'].strip())

c.close()
