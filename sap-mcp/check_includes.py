import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("D010INC", where_clause="MASTER = 'HKRCALC0'", fields=["INCLUDE"], max_rows=50)
    print("HKRCALC0 includes count:", len(r.data.get("rows", [])) if r.data else r.message)
    if r.data:
        for row in r.data.get("rows", []):
            print(row.get("INCLUDE"))

if __name__ == "__main__":
    main()
