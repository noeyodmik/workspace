import io
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**config.Settings('GY7').rfc_params())

# TFDIR 에서 INCLUDE 명칭 확인
r_src = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='MS38LFFU')
lines = [l['LINE'] for l in r_src.get('SOURCE_EXTENDED', [])]
print(f"MS38LFFU lines: {len(lines)}")
r_tf = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TFDIR',
              OPTIONS=[{'TEXT': "FUNCNAME = 'FUNCTION_EXISTS'"}],
              FIELDS=[{'FIELDNAME': 'PNAME'}, {'FIELDNAME': 'INCLUDE'}])
wa = r_tf.get('DATA', [{}])[0].get('WA', '')
pname = wa[:30].strip()
inc = wa[30:].strip()
inc_name = f"L{pname[4:]}U{inc}"
print(f"FUNCTION_EXISTS Include name: {inc_name}")
r_src = c.call('RPY_PROGRAM_READ', PROGRAM_NAME=inc_name)
lines = [l['LINE'] for l in r_src.get('SOURCE_EXTENDED', [])]
print(f"lines: {len(lines)}")
for idx, l in enumerate(lines):
    print(f"L{idx+1}: {l}")
