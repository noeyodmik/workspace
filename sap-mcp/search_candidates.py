import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())

# List candidate tables
candidates = [
    "PA0002", "PA0539", "PA0540", "PA0105", "PA0021", "PA0048",
    "PB0002", "PB0539", "HRP1000", "HRP1001", "HRP1002"
]

for tbl in candidates:
    try:
        r = b.read_table(tbl, where_clause="PERNR = '00000053'", max_rows=5)
        cnt = len(r.data.get("rows", [])) if r.data else 0
        print(f"{tbl}: {cnt} rows")
        if cnt > 0:
            for row in r.data.get("rows", []):
                print("  ", {k: v for k, v in row.items() if v.strip()})
    except Exception as e:
        print(f"{tbl} error: {e}")
