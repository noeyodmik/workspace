import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("D010TAB", where_clause="TABNAME = 'T582L'", fields=["MASTER"], max_rows=20)
    print("Programs using T582L:")
    for row in r.data.get("rows", []):
        print(row.get("MASTER"))

if __name__ == "__main__":
    main()
