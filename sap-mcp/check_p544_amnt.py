import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("PA0544", where_clause="PERNR = '00000053'", fields=["PERNR", "SUBTY", "BEGDA", "ENDDA", "IAMNT"])
print("PA0544:", r.ok, r.data.get("rows") if r.data else r.message)
