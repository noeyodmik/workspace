import io
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**config.Settings('GY7').rfc_params())

print("=== Testing RPY_PROGRAM_INSERT in GY7 ===")
prog_name = 'Z_TEST_MCP_SETUP'
code = [{'LINE': 'REPORT z_test_mcp_setup.'}, {'LINE': "WRITE: / 'Hello from GY7'."}]

try:
    r = c.call('RPY_PROGRAM_INSERT',
               PROGRAM_NAME=prog_name,
               TITLE_STRING='Test Program in GY7',
               PROGRAM_TYPE='1',
               DEVELOPMENT_CLASS='$TMP',
               TRANSPORT_NUMBER='',
               SUPPRESS_DIALOG='X',
               SAVE_INACTIVE=' ',
               SOURCE_EXTENDED=code)
    print("RPY_PROGRAM_INSERT success:", r.get('PROGRAM_NAME'))
except Exception as e:
    print("RPY_PROGRAM_INSERT error:", e)

# TRDIR 확인
r_tr = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TRDIR',
              OPTIONS=[{'TEXT': f"NAME = '{prog_name}'"}],
              FIELDS=[{'FIELDNAME': 'NAME'}, {'FIELDNAME': 'SUBC'}])
print("TRDIR for test prog in GY7:", [x.get('WA') for x in r_tr.get('DATA', [])])
