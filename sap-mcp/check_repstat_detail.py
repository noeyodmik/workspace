import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())
    
    # REPSTAT 조회
    res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='HRSFEC_D_REPSTAT',
                 FIELDS=[{'FIELDNAME': 'USER_ID'}, {'FIELDNAME': 'EMPLOYEE_ID_EXT'},
                         {'FIELDNAME': 'CUR_REPL_STATUS'}, {'FIELDNAME': 'NUMBER_OF_FAILED_ATTEMPTS'},
                         {'FIELDNAME': 'CUR_REPL_END_DATETIME'}],
                 ROWCOUNT=5)
    print('=== HRSFEC_D_REPSTAT Sample ===')
    for r in res.get('DATA', []):
        print(r.get('WA'))

    # REPSMSG 조회
    res_msg = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='HRSFEC_D_REPSMSG',
                     FIELDS=[{'FIELDNAME': 'PERNR'}, {'FIELDNAME': 'INFTY'}, {'FIELDNAME': 'MSGTY'},
                             {'FIELDNAME': 'MSGID'}, {'FIELDNAME': 'MSGNO'}, {'FIELDNAME': 'MSGV1'}, {'FIELDNAME': 'MSGV2'}],
                     ROWCOUNT=5)
    print('\n=== HRSFEC_D_REPSMSG Sample ===')
    for r in res_msg.get('DATA', []):
        print(r.get('WA'))

if __name__ == "__main__":
    main()
