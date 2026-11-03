import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ENHHEADER',
           OPTIONS=[{'TEXT': "ENHNAME = 'ZHRSFEC_B_CE_CHANGE_IT0008'"}])
for d in r.get('DATA', []):
    print("ENHHEADER:", d['WA'])

# Check filter values in BAdI
r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ENHBADIFLGV',
            OPTIONS=[{'TEXT': "ENHNAME = 'ZHRSFEC_B_CE_CHANGE_IT0008'"}])
for d in r2.get('DATA', []):
    print("ENHBADIFLGV:", d['WA'])

c.close()

