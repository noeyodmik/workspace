import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("DD03L", where_clause="TABNAME = 'PA0540'", fields=["FIELDNAME"])
print("PA0540 fields:", [row.get("FIELDNAME") for row in r.data.get("rows", [])] if r.data else r.message)

r0 = b.read_table("PA0540", max_rows=5)
print("PA0540 sample rows:", r0.data.get("rows", []) if r0.data else r0.message)
