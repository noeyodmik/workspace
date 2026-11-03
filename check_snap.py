import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check SNAP table for recent short dumps
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SNAP', DELIMITER='|',
           OPTIONS=[{'TEXT': "UNAME = 'DUSER03' AND ( FLIST LIKE '%CONV%' OR FLIST LIKE '%HRSFEC%' )"}],
           FIELDS=[{'FIELDNAME': 'DATUM'}, {'FIELDNAME': 'UZEIT'}, {'FIELDNAME': 'AINFO'}, {'FIELDNAME': 'MODNO'}])
print("Dumps found:", len(r['DATA']))
for x in r['DATA'][-5:]:
    print(x['WA'].strip())

c.close()

