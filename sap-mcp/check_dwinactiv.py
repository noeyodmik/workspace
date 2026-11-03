import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings('GY7'))
r = b.read_table("DWINACTIV", where_clause="UNAME = 'SEPPIN'", fields=["OBJECT", "OBJ_NAME", "UNAME"])
print("DWINACTIV rows on GY7:")
for row in r.data.get("rows", []):
    print(row)
