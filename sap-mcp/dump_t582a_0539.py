import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("T582A", where_clause="INFTY = '0002'")
if r.data:
    row = r.data.get("rows")[0]
    print("T582A 0002:", {k: v for k, v in row.items() if v.strip()})
else:
    print(r.message)
