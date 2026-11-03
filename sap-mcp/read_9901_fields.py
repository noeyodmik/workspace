import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    # 1. T77SFEC_PTP_CONF 필드 목록
    res_f = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
                   OPTIONS=[{'TEXT': "TABNAME = 'T77SFEC_PTP_CONF'"}],
                   FIELDS=[{'FIELDNAME': 'FIELDNAME'}])
    fields = [r['WA'].strip() for r in res_f.get('DATA', []) if r['WA'].strip() != 'MANDT']
    
    # 2. 9901_K0 필드별 값 조회 (5개씩 분할 조회하여 버퍼 초과 방지)
    print('=== 9901_K0 Field Values ===')
    field_vals = {}
    for i in range(0, len(fields), 4):
        chunk = [{'FIELDNAME': f} for f in fields[i:i+4]]
        r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='T77SFEC_PTP_CONF',
                   OPTIONS=[{'TEXT': "CONFIG_ID = '9901_K0'"}],
                   FIELDS=chunk)
        if r.get('DATA'):
            wa = r['DATA'][0]['WA']
            print(f'Chunk {i}: {wa}')

if __name__ == "__main__":
    main()
