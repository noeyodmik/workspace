import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("DD03L", where_clause="TABNAME = 'PA0544'", fields=["FIELDNAME"])
fields = [row["FIELDNAME"] for row in r.data.get("rows", []) if not row["FIELDNAME"].startswith(".")]
print("PA0544 field names:", fields)

r2 = b.read_table("PA0544", where_clause="PERNR = '00000053'", fields=["PERNR", "SUBTY", "BEGDA", "ENDDA", "BETRG"])
print("PA0544 rows:", r2.data.get("rows"))
