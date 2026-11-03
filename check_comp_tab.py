import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Find rowtype of PAD_SFEC_CE_COMPENSATION_TAB
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD40L', DELIMITER='|',
           OPTIONS=[{'TEXT': "TYPENAME = 'PAD_SFEC_CE_COMPENSATION_TAB'"}],
           FIELDS=[{'FIELDNAME': 'ROWTYPE'}])
rowtype = r['DATA'][0]['WA'].strip()
print("Rowtype:", rowtype)

r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L', DELIMITER='|',
            OPTIONS=[{'TEXT': f"TABNAME = '{rowtype}'"}],
            FIELDS=[{'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'ROLLNAME'}])
for x in r2['DATA']:
    print(x['WA'].strip())

c.close()

