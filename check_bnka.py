import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='BNKA', DELIMITER='|',
           OPTIONS=[{'TEXT': "BANKS = 'KR'"}],
           FIELDS=[{'FIELDNAME': 'BANKS'}, {'FIELDNAME': 'BANKL'}, {'FIELDNAME': 'BANKA'}])
print(f"Total KR banks in BNKA: {len(r['DATA'])}")
for x in r['DATA']:
    print(x['WA'].strip())

