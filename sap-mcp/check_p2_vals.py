import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("PA0002", where_clause="PERNR = '00000053'", fields=["PERNR", "NACHN", "VORNA", "PERID", "CNAME", "NACH2", "NAME2", "RUFNM"])
print("PA0002 names:", r.data.get("rows"))
