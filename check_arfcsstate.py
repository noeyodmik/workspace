import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

print("=== Checking ARFCSSTATE ===")
try:
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ARFCSSTATE', DELIMITER='|',
               FIELDS=[{'FIELDNAME': 'ARFCDEST'}, {'FIELDNAME': 'ARFCUSER'}, {'FIELDNAME': 'ARFCDAT'}, {'FIELDNAME': 'ARFCTIME'}, {'FIELDNAME': 'ARFCSTATE'}])
    print(f"Total ARFCSSTATE: {len(r['DATA'])}")
    for d in r['DATA']:
        print(d['WA'].strip())
except Exception as e:
    print("ARFCSSTATE err:", e)

print("\n=== Checking ARFCSDATA ===")
try:
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='ARFCSDATA', DELIMITER='|',
               FIELDS=[{'FIELDNAME': 'ARFCDEST'}, {'FIELDNAME': 'ARFCFNAM'}])
    print(f"Total ARFCSDATA: {len(r['DATA'])}")
    for d in r['DATA']:
        print(d['WA'].strip())
except Exception as e:
    print("ARFCSDATA err:", e)

c.close()

