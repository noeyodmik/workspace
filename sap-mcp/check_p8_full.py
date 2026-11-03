import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("PA0008", where_clause="PERNR = '00000053'")
if r.data and r.data.get("rows"):
    row = r.data["rows"][0]
    print("PA0008 row:")
    for k, v in row.items():
        if v.strip():
            print(f"  {k}: {v}")
