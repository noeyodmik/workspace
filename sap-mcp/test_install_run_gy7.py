import io
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**config.Settings('GY7').rfc_params())

try:
    code = [
        {'LINE': 'REPORT z_run_test.'},
        {'LINE': 'DATA: lv_time TYPE sy-uzeit.'},
        {'LINE': 'lv_time = sy-uzeit.'},
        {'LINE': "WRITE: / 'Current Server Time:', lv_time."},
        {'LINE': "WRITE: / 'System ID:', sy-sysid."}
    ]
    r = c.call('RFC_ABAP_INSTALL_AND_RUN', MODE='F', PROGRAM=code)
    print('Execution output:')
    for row in r.get('WRITES', []):
        print(" ", row)
except Exception as e:
    print('RFC_ABAP_INSTALL_AND_RUN in GY7 error:', e)
