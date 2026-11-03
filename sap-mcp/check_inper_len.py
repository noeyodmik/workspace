import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())
    res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD04L',
                 OPTIONS=[{'TEXT': "ROLLNAME = 'INPER'"}],
                 FIELDS=[{'FIELDNAME': 'ROLLNAME'}, {'FIELDNAME': 'DOMNAME'}, {'FIELDNAME': 'DATATYPE'}, {'FIELDNAME': 'LENG'}])
    print('DD04L:', res.get('DATA'))
    res2 = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
                  OPTIONS=[{'TEXT': "TABNAME = 'PC261' AND FIELDNAME = 'INPER'"}],
                  FIELDS=[{'FIELDNAME': 'TABNAME'}, {'FIELDNAME': 'FIELDNAME'}, {'FIELDNAME': 'ROLLNAME'}, {'FIELDNAME': 'LENG'}])
    print('PC261-INPER:', res2.get('DATA'))

if __name__ == "__main__":
    main()
