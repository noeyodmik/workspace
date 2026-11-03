import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())

kr_tabs = ["PA0539", "PA0540", "PA0541", "PA0542", "PA0543", "PA0544", "PA0545", "PA0546", "PA0547", "PA0548", "PA0549"]
for t in kr_tabs:
    try:
        r = b.read_table(t, where_clause="PERNR = '00000053'", fields=["PERNR", "BEGDA", "ENDDA"], max_rows=5)
        cnt = len(r.data.get("rows", [])) if r.data else 0
        print(f"{t}: {cnt} rows")
    except Exception as e:
        print(f"{t} err: {e}")
