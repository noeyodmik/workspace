import io
import sys
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    s = Settings()
    c = Connection(**s.rfc_params())
    res = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TFDIR',
                 OPTIONS=[{'TEXT': "FUNCNAME = 'Z_MCP_GET_PAYROLL_RESULT'"}],
                 FIELDS=[{'FIELDNAME': 'FUNCNAME'}, {'FIELDNAME': 'PNAME'}, {'FIELDNAME': 'INCLUDE'}])
    print('TFDIR:', res.get('DATA'))
    inc = 'LZMCPU' + res.get('DATA')[0]['WA'].split()[2]
    print('Include:', inc)
    src_res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU10')
    src = '\n'.join([l['LINE'] for l in src_res.get('SOURCE_EXTENDED', [])])
    print('Source:\n', src)

if __name__ == "__main__":
    main()
