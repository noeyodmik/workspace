import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.get_source("PROG", "MP000200")
print("MP000200 ok:", r.ok)
if r.ok and r.data:
    lines = r.data.splitlines()
    print("MP000200 lines:", len(lines))
    for i, line in enumerate(lines):
        if any(w in line.upper() for w in ["REGNO", "LNMHG", "0539", "P0539", "MOLGA"]):
            print(f"L{i+1}: {line.strip()}")
