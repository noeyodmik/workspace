import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())

    for dest in ['100_EY', '100_SD']:
        res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='RFCDES',
                     OPTIONS=[{'TEXT': f"RFCDEST = '{dest}'"}],
                     FIELDS=[{'FIELDNAME': 'RFCDEST'}, {'FIELDNAME': 'RFCOPTIONS'}, {'FIELDNAME': 'RFCTYPE'}])
        print(f'=== {dest} in RFCDES ===')
        for r in res.get('DATA', []):
            print(r.get('WA'))

if __name__ == "__main__":
    main()
