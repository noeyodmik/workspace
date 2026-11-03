import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T552A", where_clause="JAHR = '2020' AND MONAT = '01'", fields=["MOTPR", "TPROG", "VARIA", "JAHR", "MONAT"], max_rows=10)
    print("T552A (2020/01) ok:", r.ok, "msg:", r.message)
    if r.data:
        print("T552A count:", len(r.data.get("rows", [])))
        print("T552A sample:", json.dumps(r.data.get("rows", []), indent=2, ensure_ascii=False))

    r_all = b.read_table("T552A", where_clause="JAHR = '2020'", fields=["JAHR", "MONAT"], max_rows=10)
    print("T552A 2020 all count:", len(r_all.data.get("rows", [])) if r_all.data else 0)

if __name__ == "__main__":
    main()
