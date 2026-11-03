import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.get_source("INCL", "LZMCPU12")
if r.ok and r.data:
    with open("current_in_sap.txt", "w", encoding="utf-8") as f:
        f.write(r.data)
    print("Saved current source to current_in_sap.txt, length:", len(r.data))
