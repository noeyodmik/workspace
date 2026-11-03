import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T582L", where_clause="INFTY = '0539'")
    print("T582L for 0539:")
    for row in r.data.get("rows", []):
        print(row)

if __name__ == "__main__":
    main()
