import io
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**config.Settings('GY7').rfc_params())

res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='E070',
             OPTIONS=[{'TEXT': "STRKORR = 'GY7K901779' OR STRKORR = 'GY7K901907'"}],
             FIELDS=[{'FIELDNAME': 'TRKORR'}, {'FIELDNAME': 'STRKORR'}, {'FIELDNAME': 'AS4USER'}, {'FIELDNAME': 'TRSTATUS'}])
print('Subtasks in GY7 count:', len(res.get('DATA', [])))
for r in res.get('DATA', []):
    print(' ', r.get('WA'))
