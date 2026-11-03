import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

fields = ['MANDT', 'USER_ID', 'EMPLOYEE_ID_EXT', 'CUR_REPL_STATUS', 'CUR_REPL_END_DATETIME', 'LAST_SUCCESS_REPL_END_DATETIME', 'NUMBER_OF_FAILED_ATTEMPTS']
rfc_fields = [{'FIELDNAME': f} for f in fields]

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='HRSFEC_D_REPSTAT',
           FIELDS=rfc_fields,
           OPTIONS=[{'TEXT': "USER_ID = '70000017' OR USER_ID = '70000019'"}])

for d in r.get('DATA', []):
    print("REPSTAT USER_ID:", d['WA'])

r2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='HRSFEC_D_REPSTAT',
            FIELDS=rfc_fields,
            OPTIONS=[{'TEXT': "EMPLOYEE_ID_EXT = '70000017' OR EMPLOYEE_ID_EXT = '70000019'"}])

for d in r2.get('DATA', []):
    print("REPSTAT EMPLOYEE_ID_EXT:", d['WA'])

c.close()

