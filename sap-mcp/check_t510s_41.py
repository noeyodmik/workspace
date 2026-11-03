import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T510S", where_clause="MOLGA = '41'", fields=["MOLGA", "ORGMO", "SEQNO", "LGART", "BEGDA", "ENDDA"], max_rows=20)
    print("T510S (MOLGA=41) count:", len(r.data.get("rows", [])))
    print("T510S rows:", json.dumps(r.data.get("rows", []), indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()
