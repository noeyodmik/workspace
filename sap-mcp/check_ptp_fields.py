import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())
    
    for tbl in ['HRSFEC_D_REPSTAT', 'HRSFEC_D_REPSMSG', 'HRSFEC_D_EEKEYMP']:
        res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
                     OPTIONS=[{'TEXT': f"TABNAME = '{tbl}'"}],
                     FIELDS=[{'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'ROLLNAME'}, {'FIELDNAME': 'LENG'}])
        fields = [r['WA'].split()[0] for r in res.get('DATA', [])]
        print(f'=== {tbl} Fields ===')
        print(', '.join(fields[:15]))

        # 실제 데이터 3건 샘플 조회
        try:
            data = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=tbl, ROWCOUNT=3)
            print(f'Sample {tbl} count:', len(data.get('DATA', [])))
            for d in data.get('DATA', []):
                print(' ', d.get('WA')[:120])
        except Exception as e:
            print('Read error:', e)
        print()

if __name__ == "__main__":
    main()
