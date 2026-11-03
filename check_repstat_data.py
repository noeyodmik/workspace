import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='HRSFEC_D_REPSTAT', DELIMITER='|',
           FIELDS=[{'FIELDNAME': 'EMPLOYEE_ID_EXT'}, {'FIELDNAME': 'CUR_REPL_STATUS'},
                   {'FIELDNAME': 'CUR_REPL_SRT_MSGID'}, {'FIELDNAME': 'LAST_SUCCESS_REPL_SRT_MSGID'}])

print(f"Total HRSFEC_D_REPSTAT: {len(r['DATA'])}")
for d in r['DATA']:
    print(d['WA'].strip())

c.close()

