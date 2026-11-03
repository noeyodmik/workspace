import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
with b._conn() as c:
    d_read = c.get_function_description("RPY_INCLUDE_READ")
    print("RPY_INCLUDE_READ params:")
    for p in d_read.parameters:
        print(f"  {p['name']}: {p['direction']}")
        
    d_up = c.get_function_description("RPY_INCLUDE_UPDATE")
    print("\nRPY_INCLUDE_UPDATE params:")
    for p in d_up.parameters:
        print(f"  {p['name']}: {p['direction']}")
