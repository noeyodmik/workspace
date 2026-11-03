import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.get_source("PROG", "P0002KR3")
if r.ok and r.data:
    lines = r.data.splitlines()
    for i in range(max(0, 50), min(len(lines), 120)):
        print(f"L{i+1}: {lines[i]}")
