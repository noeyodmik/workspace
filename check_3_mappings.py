import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

for dt in ['PAYMENT_METHOD', 'PAY_COMPONENT', 'ADDRESS_TYPE', 'ADDRESSES']:
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_CVMAPC', DELIMITER='|',
               OPTIONS=[{'TEXT': f"EC_DATA_TYPE = '{dt}'"}])
    print(f"=== T77SFEC_CVMAPC ({dt}) ===")
    for x in r['DATA']:
        print(" ", x['WA'])

for dt in ['PAYMENT_METHOD', 'PAY_COMPONENT', 'ADDRESS_TYPE', 'ADDRESSES']:
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_CVPROPC', DELIMITER='|',
               OPTIONS=[{'TEXT': f"EC_DATA_TYPE = '{dt}'"}])
    print(f"=== T77SFEC_CVPROPC ({dt}) ===")
    for x in r['DATA']:
        print(" ", x['WA'])
    r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_CVPROPS', DELIMITER='|',
                OPTIONS=[{'TEXT': f"EC_DATA_TYPE = '{dt}'"}])
    print(f"=== T77SFEC_CVPROPS ({dt}) ===")
    for x in r2['DATA']:
        print(" ", x['WA'])

# Check T512Z for MOLGA 41 and LGART 1010 or INFTY 0008
r512 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T512Z', DELIMITER='|',
              OPTIONS=[{'TEXT': "MOLGA = '41' AND LGART = '1010'"}],
              FIELDS=[{'FIELDNAME': 'MANDT'}, {'FIELDNAME': 'MOLGA'}, {'FIELDNAME': 'INFTY'}, {'FIELDNAME': 'LGART'}, {'FIELDNAME': 'ENDDA'}, {'FIELDNAME': 'BEGDA'}])
print("=== T512Z (41, 1010) ===")
for x in r512['DATA']:
    print(" ", x['WA'])

