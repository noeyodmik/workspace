import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    for tbl in ['RFCDISPLAY', 'RFCATTRIB']:
        try:
            res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=tbl,
                         OPTIONS=[{'TEXT': "RFCDEST = 'ECP_PTP_ODATA_100' OR RFCDEST = 'EC_BASIC'"}],
                         ROWCOUNT=5)
            print(f'=== {tbl} ===')
            for r in res.get('DATA', []):
                print(' ', r.get('WA'))
        except Exception as e:
            print(f'{tbl} error:', e)

if __name__ == "__main__":
    main()
