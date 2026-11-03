import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    # 1. T77SFEC_PTP_SEGM 필드 확인
    res_f = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
                   OPTIONS=[{'TEXT': "TABNAME = 'T77SFEC_PTP_SEGM'"}],
                   FIELDS=[{'FIELDNAME': 'FIELDNAME'}])
    print('Fields:', [r['WA'].strip() for r in res_f.get('DATA', [])])

    # 2. 내용 확인
    res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_PTP_SEGM')
    print('Count in T77SFEC_PTP_SEGM:', len(res.get('DATA', [])))
    for r in res.get('DATA', []):
        print(' ', r.get('WA'))

if __name__ == "__main__":
    main()
