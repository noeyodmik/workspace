import io
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**config.Settings('GY7').rfc_params())

r = c.call('RFC_GET_FUNCTION_INTERFACE', FUNCNAME='RS_FUNCTIONMODULE_INSERT')
print("RS_FUNCTIONMODULE_INSERT params:")
for p in r.get('PARAMS', []):
    print(f"  {p.get('PARAMCLASS')}: {p.get('PARAMETER')} ({p.get('TABNAME')})")
