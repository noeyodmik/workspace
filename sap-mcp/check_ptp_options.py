import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='RFCDES',
                 OPTIONS=[{'TEXT': "RFCDEST = 'ECP_PTP_ODATA_100' OR RFCDEST = 'EC_BASIC'"}],
                 FIELDS=[{'FIELDNAME': 'RFCDEST'}, {'FIELDNAME': 'RFCOPTIONS'}])
    for r in res.get('DATA', []):
        print(r.get('WA'))

if __name__ == "__main__":
    main()
