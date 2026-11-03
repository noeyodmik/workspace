import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    # T77SFEC_* 중에서 FIELDNAME = 'RFCDEST' 가진 테이블 찾기
    res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
                 OPTIONS=[{'TEXT': "TABNAME LIKE 'T77SFEC_%' AND FIELDNAME = 'RFCDEST'"}],
                 FIELDS=[{'FIELDNAME': 'TABNAME'}, {'FIELDNAME': 'FIELDNAME'}])
    print('Tables with RFCDEST:')
    tables = set()
    for r in res.get('DATA', []):
        t = r['WA'].split()[0]
        tables.add(t)
        print(' ', r.get('WA'))

    # 각 테이블 내용 조회
    for tbl in tables:
        try:
            d = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=tbl, ROWCOUNT=5)
            print(f'=== {tbl} Data ({len(d.get("DATA", []))} rows) ===')
            for row in d.get('DATA', []):
                print(' ', row.get('WA'))
        except Exception as e:
            print(f'{tbl} read error:', e)

if __name__ == "__main__":
    main()
