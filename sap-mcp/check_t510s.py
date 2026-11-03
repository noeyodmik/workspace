import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T510S", where_clause="MOLGA = '41'", fields=["MOLGA", "MOZKO", "MODIF", "LGART", "BEGDA", "ENDDA"], max_rows=20)
    print("T510S (MOLGA=41) ok:", r.ok, "msg:", r.message)
    print("T510S rows:", json.dumps(r.data.get("rows", []), indent=2, ensure_ascii=False))

    r_all = b.read_table("T510S", fields=["MOLGA", "MOZKO", "MODIF", "LGART"], max_rows=10)
    print("T510S sample:", json.dumps(r_all.data.get("rows", []), indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()
