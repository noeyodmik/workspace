import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.get_source("PROG", "%_CPKR00")
if r.ok and r.data:
    lines = r.data.splitlines() if isinstance(r.data, str) else []
    for i, l in enumerate(lines):
        if any(k in l.upper() for k in ["0539", "0540", "KRTAX", "KRSIP"]):
            print(f"L{i+1}: {l.strip()}")
