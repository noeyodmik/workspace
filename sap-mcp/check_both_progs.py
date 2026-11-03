import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
for prog in ["Z_INS_PA0539_TMP", "Z_INS_PA0539_DATA"]:
    r2 = b.read_table("TRDIR", where_clause=f"NAME = '{prog}'", fields=["NAME", "SUBC", "CNAM", "CDAT"])
    print(f"TRDIR {prog}:", r2.ok, r2.data.get("rows") if r2.data else r2.message)
