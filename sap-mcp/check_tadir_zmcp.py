import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("TADIR", where_clause="PGMID = 'R3TR' AND OBJECT = 'FUGR' AND OBJ_NAME = 'ZMCP'")
print("TADIR FUGR ZMCP:", r.data.get("rows"))
