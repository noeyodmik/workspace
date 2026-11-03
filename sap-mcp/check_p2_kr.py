import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
for inc in ["P0002KR1", "P0002KR2", "P0002KR3", "P0002KR4"]:
    r = b.get_source("PROG", inc)
    print(f"=== {inc} ===")
    if r.ok and r.data:
        print(r.data[:1500])
