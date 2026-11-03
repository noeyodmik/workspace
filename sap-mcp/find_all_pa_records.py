import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())

# Find all tables with PERNR
tables_res = b.read_table("DD03L", where_clause="FIELDNAME = 'PERNR' AND TABNAME LIKE 'PA0%'", fields=["TABNAME"], max_rows=200)
tabs = sorted(list(set(r["TABNAME"] for r in tables_res.data.get("rows", []))))
print("Candidate PA tables:", len(tabs))

found = {}
for t in tabs:
    try:
        r = b.read_table(t, where_clause="PERNR = '00000053'", fields=["PERNR", "BEGDA", "ENDDA"], max_rows=5)
        if r.data and r.data.get("rows"):
            found[t] = len(r.data["rows"])
    except Exception:
        pass

print("Tables with rows for 53:")
print(json.dumps(found, indent=2))
