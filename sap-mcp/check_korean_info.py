import io
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())

# check PA0539 again
res = b.read_table("PA0539", fields=["PERNR", "BEGDA", "ENDDA", "REGNO", "LNMHG", "FNMHG"])
print("All PA0539:", res.data.get("rows", []))

# check PB0002 or HRP1000 or other tables
for tbl in ["PA0002", "PB0002", "PA0539", "PA0540", "PA0105"]:
    try:
        r = b.read_table(tbl, where_clause="PERNR = '00000053'", max_rows=5)
        print(f"{tbl}: {len(r.data.get('rows', []))} rows")
    except Exception as e:
        print(f"{tbl}: {e}")
