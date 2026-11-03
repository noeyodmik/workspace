import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    # SM59 HTTP Destination 테이블: RFCDES
    res_dest = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='RFCDES',
                      OPTIONS=[{'TEXT': "RFCTYPE = 'G'"}],
                      FIELDS=[{'FIELDNAME': 'RFCDEST'}])
    print('=== HTTP Destinations (Type G) ===')
    for r in res_dest.get('DATA', []):
        dest_name = r.get('WA').strip()
        print(' -', dest_name)

if __name__ == "__main__":
    main()
