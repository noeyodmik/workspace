import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("DD03L", where_clause="TABNAME = 'PA0540' AND FIELDNAME = 'FAMID'", fields=["ROLLNAME", "DATATYPE", "LENG"])
print("FAMID in PA0540:", r.data.get("rows"))
