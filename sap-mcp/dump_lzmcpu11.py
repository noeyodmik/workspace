import io
import sys
from config import Settings
from backends.rfc_backend import RfcBackend

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
b = RfcBackend(Settings())
r = b.get_source("INCL", "LZMCPU11")
if r.ok:
    with open("lzmcpu11_full.txt", "w", encoding="utf-8") as f:
        f.write(r.data)
    print("Saved lzmcpu11_full.txt, lines:", len(r.data.splitlines()))
else:
    print("Failed:", r.message)
