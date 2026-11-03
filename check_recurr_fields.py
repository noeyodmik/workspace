import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD40L', DELIMITER='|',
           OPTIONS=[{'TEXT': "TYPENAME = 'PAD_SFEC_CE_PAYCOMP_RECURR_TAB'"}],
           FIELDS=[{'FIELDNAME': 'ROWTYPE'}])
rowtype = r['DATA'][0]['WA'].strip()
print("ROWTYPE:", rowtype)

r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
            OPTIONS=[{'TEXT': f"TABNAME = '{rowtype}' AND AS4LOCAL = 'A'"}],
            FIELDS=[{'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'ROLLNAME'}])
for x in r2['DATA']:
    print(x['WA'].strip())

