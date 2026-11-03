import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("DD03L", where_clause="TABNAME = 'T550A'", fields=["FIELDNAME", "POSITION"], max_rows=20)
    print("T550A fields:", [row.get("FIELDNAME") for row in r.data.get("rows", [])])

if __name__ == "__main__":
    main()
