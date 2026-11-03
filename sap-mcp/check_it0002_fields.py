import io
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
p2 = b.read_table("PA0002", fields=["PERNR", "BEGDA", "ENDDA", "NACHN", "VORNA", "PERID", "GBDAT"], where_clause="PERNR = '00000053'")
print("PA0002 rows:", p2.data.get("rows", []))
