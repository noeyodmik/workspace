import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

fields = [
    {'FIELDNAME': 'EMPLOYEE_ID_EXT'},
    {'FIELDNAME': 'CUR_REPL_STATUS'},
    {'FIELDNAME': 'LAST_SUCCESS_REPL_END_DATETIME'},
    {'FIELDNAME': 'CUR_REPL_CE_START_DATETIME'}
]

res = c.call('BBP_RFC_READ_TABLE', 
             QUERY_TABLE='HRSFEC_D_REPSTAT',
             FIELDS=fields)

for r in res['DATA']:
    print("REPSTAT:", r['WA'])

