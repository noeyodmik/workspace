import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("D021S", where_clause="PROG = 'MP000200'", fields=["DYNR", "FNAM"], max_rows=50)
print(r.ok, r.message)
