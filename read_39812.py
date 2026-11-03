import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

res = c.call('APPL_LOG_READ_INTERN',
             OBJECT='HRSFEC',
             SUBOBJECT='EMPLOYEE_PTP',
             LOGNUMBER='00000000000000039812')

print("Log 39812 messages:")
for m in res['HEADER_DATA']:
    print("Header:", m)
for m in res['MESSAGES']:
    print(f"[{m.get('MSGTY')}] {m.get('MSGID')} {m.get('MSGNO')}: V1={m.get('MSGV1')} V2={m.get('MSGV2')}")

