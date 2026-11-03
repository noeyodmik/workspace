import io
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**config.Settings('GY7').rfc_params())

res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TRDIR',
             OPTIONS=[{'TEXT': "NAME = 'SAPLZMCP' OR NAME = 'LZMCPTOP'"}],
             FIELDS=[{'FIELDNAME': 'NAME'}, {'FIELDNAME': 'SUBC'}])
for r in res.get('DATA', []):
    print(r.get('WA'))
