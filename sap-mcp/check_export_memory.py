import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
with b._conn() as c:
    r = c.call("RPY_PROGRAM_READ", PROGRAM_NAME="HKRCALC0")
    src = [line["LINE"] for line in r.get("SOURCE_EXTENDED", [])]
    for i, line in enumerate(src):
        if "EXPORT" in line and "MEMORY" in line:
            print(f"L{i+1}: {line}")
