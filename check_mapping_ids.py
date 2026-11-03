import sys, io
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

print("=== HRSFEC_D_EEKEYMP ===")
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='HRSFEC_D_EEKEYMP', DELIMITER='|',
           FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'EMPLOYEE_ID_EXT'}, {'FIELDNAME': 'PERSON_ID_INTERNAL'}])
for d in r['DATA']:
    print(d['WA'].strip())

print("\n=== PA0709 ===")
r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='PA0709', DELIMITER='|',
           FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'PERSONID_EXT'}])
for d in r['DATA']:
    print(d['WA'].strip())

c.close()

