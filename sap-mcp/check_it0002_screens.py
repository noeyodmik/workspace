import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("T582A", where_clause="INFTY = '0002'", fields=["INFTY", "DNAME", "DYNNR"])
print("T582A ok:", r.ok, r.message)

r_m = b.read_table("T588M", where_clause="INFTY = '0002' AND MOLGA = '41'", fields=["DYNNR", "MODIF"])
print("T588M ok:", r_m.ok, r_m.message)
