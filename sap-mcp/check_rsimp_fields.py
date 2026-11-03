import io
import json
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

c = Connection(**config.Settings('GY7').rfc_params())

# RSIMP, RSEXP 구조 확인
for tab in ['RSIMP', 'RSEXP', 'RSTBL', 'RSEXC', 'RSCHA']:
    res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L',
                 OPTIONS=[{'TEXT': f"TABNAME = '{tab}'"}],
                 FIELDS=[{'FIELDNAME': 'FIELDNAME'}])
    print(tab, 'fields:', [r['WA'].strip() for r in res.get('DATA', []) if r['WA'].strip() not in ('MANDT',)])
