import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
with b._conn() as c:
    desc = c.get_function_description("RPY_PROGRAM_INSERT")
    print("RPY_PROGRAM_INSERT parameters:")
    for param in desc.parameters:
        print(f"  {param.get('name')}: direction={param.get('direction')}, type={param.get('type_description')}")
