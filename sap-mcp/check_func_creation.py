import io
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

c_ea3 = Connection(**config.Settings('EA3').rfc_params())
c_gy7 = Connection(**config.Settings('GY7').rfc_params())

print("=== Checking Function Creation FMs in GY7 ===")
candidates = [
    'RS_FUNCTION_MODULE_INSERT',
    'RPY_FUNCTIONMODULE_INSERT',
    'RPY_FUNCTIONGROUP_CREATE',
    'RS_FUNCTION_POOL_INSERT',
    'RFC_GET_FUNCTION_INTERFACE',
    'BAPI_FUNCTIONGROUP_CREATE',
    'RS_FUNCTIONMODULE_CREATE'
]

for fn in candidates:
    remote_gy7 = False
    try:
        r = c_gy7.call('RFC_FUNCTION_SEARCH', FUNCNAME=fn)
        remote_gy7 = any(f.get('FUNCNAME') == fn for f in r.get('FUNCTIONS', []))
    except Exception:
        pass
    print(f"GY7 {fn}: {remote_gy7}")
