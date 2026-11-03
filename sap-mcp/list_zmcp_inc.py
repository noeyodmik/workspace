import io
import sys
from config import Settings
from backends.rfc_backend import RfcBackend

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
b = RfcBackend(Settings())
r = b.read_table("TFDIR", where_clause="PNAME = 'SAPLZMCP'", fields=["FUNCNAME", "INCLUDE"])
if r.ok:
    for row in r.data.get("rows", []):
        print(f"LZMCPU{row.get('INCLUDE')}: {row.get('FUNCNAME')}")
else:
    print("Failed:", r.message)
