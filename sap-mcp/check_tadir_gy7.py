import io
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**config.Settings('GY7').rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TADIR',
           OPTIONS=[{'TEXT': "OBJ_NAME = 'ZMCP'"}],
           FIELDS=[{'FIELDNAME': 'PGMID'}, {'FIELDNAME': 'OBJECT'}, {'FIELDNAME': 'OBJ_NAME'}, {'FIELDNAME': 'DEVCLASS'}])
print("TADIR ZMCP in GY7 count:", len(r.get('DATA', [])))
for row in r.get('DATA', []):
    print(" ", row.get('WA'))
