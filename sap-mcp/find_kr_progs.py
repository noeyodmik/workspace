import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("TRDIR", where_clause="NAME LIKE 'RPC%KR%' OR NAME LIKE 'RPU%KR%'", fields=["NAME"], max_rows=30)
    print("KR programs:")
    for row in r.data.get("rows", []):
        print(row.get("NAME"))

if __name__ == "__main__":
    main()
