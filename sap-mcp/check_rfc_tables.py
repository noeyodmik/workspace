import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    # RFCDES 테이블 필드
    res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
                 OPTIONS=[{'TEXT': "TABNAME = 'RFCDES'"}],
                 FIELDS=[{'FIELDNAME': 'FIELDNAME'}])
    print('RFCDES:', [r['WA'].strip() for r in res.get('DATA', [])])

    # RFCDEST로 시작하는 테이블들 검색
    res2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD02L',
                  OPTIONS=[{'TEXT': "TABNAME LIKE 'RFC%'"}],
                  FIELDS=[{'FIELDNAME': 'TABNAME'}],
                  ROWCOUNT=30)
    print('RFC Tables:', [r['WA'].strip() for r in res2.get('DATA', [])])

if __name__ == "__main__":
    main()
