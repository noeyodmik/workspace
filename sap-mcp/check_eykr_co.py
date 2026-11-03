import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    # T001에서 EYKR과 1101 비교
    res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T001',
                 OPTIONS=[{'TEXT': "BUKRS = 'EYKR' OR BUKRS = '1101'"}],
                 FIELDS=[{'FIELDNAME': 'BUKRS'}, {'FIELDNAME': 'BUTXT'}, {'FIELDNAME': 'KOKFI'}])
    print('=== T001 (KOKFI) ===')
    for r in res.get('DATA', []):
        print(' ', r.get('WA'))

    # T001K (원가회계영역 배정 지시자 테이블) 또는 TKA02 (회사코드 -> 관리회계영역 배정) 확인!
    res_co = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TKA02',
                    OPTIONS=[{'TEXT': "BUKRS = 'EYKR' OR BUKRS = '1101'"}],
                    FIELDS=[{'FIELDNAME': 'BUKRS'}, {'FIELDNAME': 'KOKRS'}])
    print('\n=== TKA02 (CO Area Assignment) ===')
    for r in res_co.get('DATA', []):
        print(' ', r.get('WA'))

if __name__ == "__main__":
    main()
