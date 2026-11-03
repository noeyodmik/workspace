import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("PA0539", where_clause="PERNR = '00000053'")
    print("PA0539 rows:", r.data.get("rows") if r.data else r.message)

    r44 = b.read_table("PA0544", where_clause="PERNR = '00000053'")
    print("PA0544 rows count:", len(r44.data.get("rows", [])) if r44.data else r44.message)

if __name__ == "__main__":
    main()
