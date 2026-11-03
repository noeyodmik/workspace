import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

print("Step 1: Creating Bank KR / 004...")
res = c.call('BAPI_BANK_CREATE',
             BANK_CTRY='KR',
             BANK_KEY='004',
             BANK_ADDRESS={'BANK_NAME': 'KB Kookmin Bank', 'CITY': 'Seoul'})
print("BAPI_BANK_CREATE return:", res.get('RETURN'))

if not res.get('RETURN') or res.get('RETURN', {}).get('TYPE') in ('', 'S'):
    res_commit = c.call('BAPI_TRANSACTION_COMMIT', WAIT='X')
    print("Commit result:", res_commit)
else:
    print("Failed, not committing.")

# Verify BNKA
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='BNKA', DELIMITER='|',
           OPTIONS=[{'TEXT': "BANKS = 'KR' AND BANKL = '004'"}],
           FIELDS=[{'FIELDNAME': 'BANKS'}, {'FIELDNAME': 'BANKL'}, {'FIELDNAME': 'BANKA'}])
print("BNKA verification:", [x['WA'] for x in r['DATA']])

