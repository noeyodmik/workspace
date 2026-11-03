import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("TADIR", where_clause="OBJ_NAME LIKE '%0539%' AND OBJECT <> 'AVAS'", fields=["PGMID", "OBJECT", "OBJ_NAME"])
print("TADIR non-AVAS 0539 objects:")
for row in r.data.get("rows", []):
    print(row)
