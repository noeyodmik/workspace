import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TSTC',
                 OPTIONS=[{'TEXT': "TCODE = 'HRSFEC_PTP_CONFIG'"}],
                 FIELDS=[{'FIELDNAME': 'TCODE'}, {'FIELDNAME': 'PGMNA'}])
    print('TSTC:', res.get('DATA'))
    res2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TSTCP',
                  OPTIONS=[{'TEXT': "TCODE = 'HRSFEC_PTP_CONFIG'"}],
                  FIELDS=[{'FIELDNAME': 'TCODE'}, {'FIELDNAME': 'PARAM'}])
    print('TSTCP:', res2.get('DATA'))

if __name__ == "__main__":
    main()
