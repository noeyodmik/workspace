import io
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

c = Connection(**config.Settings('GY7').rfc_params())

for fm in ['RS_FUNCTION_POOL_INSERT', 'RPY_FUNCTIONMODULE_INSERT', 'RFC_GET_FUNCTION_INTERFACE']:
    print(f"\n=== Interface for {fm} ===")
    try:
        r = c.call('RFC_GET_FUNCTION_INTERFACE', FUNCNAME=fm)
        for p in r.get('PARAMS', []):
            print(f"  {p.get('PARAMCLASS')}: {p.get('PARAMETER')} ({p.get('TABNAME')})")
    except Exception as e:
        print("Error:", e)
