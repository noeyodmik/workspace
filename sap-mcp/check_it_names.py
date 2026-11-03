import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T582S", where_clause="SPRSL = '3' AND ( INFTY = '0539' OR INFTY = '0544' )", fields=["INFTY", "ITEXT"])
    print("T582S:")
    if r.data:
        for row in r.data.get("rows", []):
            print(f"IT {row.get('INFTY')}: {row.get('ITEXT')}")

if __name__ == "__main__":
    main()
