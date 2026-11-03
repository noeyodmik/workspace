import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

# Check message text of HRSFEC_CE_CONV 001
res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T100', DELIMITER='|',
             OPTIONS=[{'TEXT': "ARBGB = 'HRSFEC_CE_CONV' AND MSGNR = '001'"}])
for r in res['DATA']:
    print('T100:', r['WA'].strip())

# Check HRSFEC_COMPENSAT 000
res2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T100', DELIMITER='|',
             OPTIONS=[{'TEXT': "ARBGB = 'HRSFEC_COMPENSAT' AND MSGNR = '000'"}])
for r in res2['DATA']:
    print('T100:', r['WA'].strip())

c.close()

