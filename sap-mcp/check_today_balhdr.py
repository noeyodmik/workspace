import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings().rfc_params())

res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='BALHDR',
             OPTIONS=[{'TEXT': "OBJECT = 'HRSFEC' AND ALDATE >= '20261027'"}],
             FIELDS=[{'FIELDNAME': 'LOGNUMBER'}, {'FIELDNAME': 'ALDATE'}, {'FIELDNAME': 'ALTIME'}, {'FIELDNAME': 'ALUSER'}, {'FIELDNAME': 'EXTNUMBER'}],
             ROWCOUNT=20)
print('Recent HRSFEC logs count:', len(res.get('DATA', [])))
for r in res.get('DATA', []):
    print(' ', r.get('WA'))
