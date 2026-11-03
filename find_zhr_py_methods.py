import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SEOCOMPO',
           OPTIONS=[{'TEXT': "CLSNAME = 'ZHR_PY' AND CMPTYPE = '1'"}])
for d in r.get('DATA', []):
    print("Method:", d['WA'])

# Check SEOCMETHTXT or TMDIR
r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TMDIR',
            OPTIONS=[{'TEXT': "CLASSNAME = 'ZHR_PY'"}])
for d in r2.get('DATA', []):
    print("TMDIR:", d['WA'])

c.close()

