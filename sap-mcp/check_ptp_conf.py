import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())
    
    # 1. T77SFEC_PTP_CONF 필드 확인
    res_f = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
                   OPTIONS=[{'TEXT': "TABNAME = 'T77SFEC_PTP_CONF'"}],
                   FIELDS=[{'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'LENG'}])
    fields = [r['WA'].split()[0] for r in res_f.get('DATA', []) if r['WA'].split()[0] not in ('MANDT',)]
    print('T77SFEC_PTP_CONF Fields:', fields)

    # 2. 상위 3개 필드만 지정해서 데이터 조회
    sel_fields = [{'FIELDNAME': 'CONFIG_ID'}, {'FIELDNAME': 'COMPANY'}, {'FIELDNAME': 'TARGET_SYSTEM'}]
    res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_PTP_CONF',
                 FIELDS=sel_fields)
    print('\n=== T77SFEC_PTP_CONF Data ===')
    print('Count:', len(res.get('DATA', [])))
    for r in res.get('DATA', []):
        print(' ', r.get('WA'))

    # 3. SM59 HTTP Destination (Type G) 확인 - RFCDEST 테이블
    res_dest = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='RFCDES',
                      OPTIONS=[{'TEXT': "RFCTYPE = 'G'"}],
                      FIELDS=[{'FIELDNAME': 'RFCDEST'}, {'FIELDNAME': 'RFCTYPE'}, {'FIELDNAME': 'RFCDOC1'}],
                      ROWCOUNT=10)
    print('\n=== SM59 Type G (HTTP) Destinations ===')
    for r in res_dest.get('DATA', []):
        print(' ', r.get('WA'))

if __name__ == "__main__":
    main()
