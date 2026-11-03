import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("T588Z", where_clause="INFTY = '0002'")
if r.data:
    for row in r.data.get("rows", []):
        print(row)
else:
    print(r.message)
