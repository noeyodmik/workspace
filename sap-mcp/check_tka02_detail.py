import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
                 OPTIONS=[{'TEXT': "TABNAME = 'TKA02'"}],
                 FIELDS=[{'FIELDNAME': 'FIELDNAME'}])
    print('TKA02 fields:', [r['WA'].strip() for r in res.get('DATA', [])])

    res2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TKA02', ROWCOUNT=5)
    print('TKA02 sample data:')
    for r in res2.get('DATA', []):
        print(' ', r.get('WA'))

if __name__ == "__main__":
    main()
