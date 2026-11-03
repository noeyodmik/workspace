import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())
    
    # 1. HRSFEC_D_* 테이블 검색
    res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD02L',
                 OPTIONS=[{'TEXT': "TABNAME LIKE 'HRSFEC_D_%'"}],
                 FIELDS=[{'FIELDNAME': 'TABNAME'}, {'FIELDNAME': 'AS4USER'}])
    print('=== HRSFEC_D_* Tables ===')
    for r in res.get('DATA', []):
        print(r.get('WA'))

    # 2. T77SFEC_* 복제 설정/상태 관련 테이블
    res2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD02L',
                  OPTIONS=[{'TEXT': "TABNAME LIKE 'T77SFEC_%'"}],
                  FIELDS=[{'FIELDNAME': 'TABNAME'}])
    print('\n=== T77SFEC_* Tables ===')
    for r in res2.get('DATA', []):
        print(r.get('WA'))

if __name__ == "__main__":
    main()
