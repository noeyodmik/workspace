import io
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**config.Settings('GY7').rfc_params())

print("=== Creating Function Group ZMCP in GY7 ===")
try:
    r = c.call('RS_FUNCTION_POOL_INSERT',
               FUNCTION_POOL='ZMCP',
               SHORT_TEXT='MCP Server Function Group',
               DEVCLASS='$TMP',
               RESPONSIBLE='seppin',
               UNICODE_CHECKS='X',
               SUPPRESS_CORR_CHECK='X')
    print("RS_FUNCTION_POOL_INSERT success:", r)
except Exception as e:
    print("RS_FUNCTION_POOL_INSERT error:", e)

# TADIR 확인
r_tadir = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TADIR',
                 OPTIONS=[{'TEXT': "OBJECT = 'FUGR' AND OBJ_NAME = 'ZMCP'"}],
                 FIELDS=[{'FIELDNAME': 'PGMID'}, {'FIELDNAME': 'OBJECT'}, {'FIELDNAME': 'OBJ_NAME'}, {'FIELDNAME': 'DEVCLASS'}])
print("TADIR FUGR ZMCP in GY7:", [x.get('WA') for x in r_tadir.get('DATA', [])])
