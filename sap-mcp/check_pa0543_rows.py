import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("PA0543", where_clause="PERNR = '00000053'", fields=["PERNR", "SUBTY", "BEGDA", "ENDDA"])
print("PA0543 fields:", r.ok, r.message, r.data.get("rows") if r.data else None)
