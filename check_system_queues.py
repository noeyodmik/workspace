import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

print("=== Checking ST22 Dumps today ===")
try:
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='SNAP', DELIMITER='|',
               OPTIONS=[{'TEXT': "DATUM = '20261103'"}],
               FIELDS=[{'FIELDNAME': 'DATUM'}, {'FIELDNAME': 'UZEIT'}, {'FIELDNAME': 'AINFO'}, {'FIELDNAME': 'UNAME'}])
    print(f"Total dumps today: {len(r['DATA'])}")
    for d in r['DATA'][-10:]:
        print(d['WA'].strip())
except Exception as e:
    print("SNAP error:", e)

print("\n=== Checking ARFCSSTATE (qRFC / tRFC) ===")
try:
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ARFCSSTATE', DELIMITER='|',
               FIELDS=[{'FIELDNAME': 'ARFCDEST'}, {'FIELDNAME': 'ARFCFNAM'}, {'FIELDNAME': 'ARFCSTATE'}, {'FIELDNAME': 'ARFCDAT'}])
    print(f"Total ARFCSSTATE: {len(r['DATA'])}")
    for d in r['DATA']:
        print(d['WA'].strip())
except Exception as e:
    print("ARFCSSTATE error:", e)

print("\n=== Checking TRFCQIN (qRFC Inbound) ===")
try:
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TRFCQIN', DELIMITER='|',
               FIELDS=[{'FIELDNAME': 'QNAME'}, {'FIELDNAME': 'QSTATE'}])
    print(f"Total TRFCQIN: {len(r['DATA'])}")
    for d in r['DATA']:
        print(d['WA'].strip())
except Exception as e:
    print("TRFCQIN error:", e)

c.close()

