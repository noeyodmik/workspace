import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T510S", where_clause="MOLGA = '41'", fields=["MOLGA", "ORGMO", "SEQNO", "LGART"], max_rows=500)
    print("T510S MOLGA 41 total rows:", len(r.data.get("rows", [])) if r.data else r.message)
    orgmo_set = set(row.get("ORGMO") for row in r.data.get("rows", [])) if r.data else set()
    print("Unique ORGMO in T510S (MOLGA=41):", orgmo_set)

if __name__ == "__main__":
    main()
