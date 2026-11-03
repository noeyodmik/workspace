import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    # 1. ECP 회사코드 목록 (T001)
    res_t001 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T001',
                      FIELDS=[{'FIELDNAME': 'BUKRS'}, {'FIELDNAME': 'BUTXT'}])
    print('=== ECP Company Codes (T001) ===')
    for r in res_t001.get('DATA', []):
        print(' ', r.get('WA'))

    # 2. 회사코드 매핑 테이블 T77SFEC_KMAPCOMC
    res_map = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_KMAPCOMC')
    print('\n=== T77SFEC_KMAPCOMC (Company Code Mapping) ===')
    print('Count:', len(res_map.get('DATA', [])))
    for r in res_map.get('DATA', []):
        print(' ', r.get('WA'))

if __name__ == "__main__":
    main()
