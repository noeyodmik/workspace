import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("DD03L", where_clause="TABNAME = 'PA0002'", fields=["FIELDNAME", "ROLLNAME", "LENG"])
print("PA0002 fields count:", len(r.data.get("rows", [])))
for row in r.data.get("rows", []):
    fn = row["FIELDNAME"]
    if any(k in fn.upper() for k in ["NAME", "NACH", "VORN", "ID", "REG", "SSN", "PERID", "MID", "RUF"]):
        print(row)
