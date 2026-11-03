import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r2 = b.read_table("PA0544", where_clause="PERNR = '00000053'", fields=["PERNR", "SUBTY", "BEGDA", "ENDDA", "SIMCA"])
print("PA0544 SIMCA rows:", r2.data.get("rows"))
