import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("DD03L", where_clause="TABNAME = 'T508A'", fields=["FIELDNAME", "KEYFLAG", "ROLLNAME", "POSITION"], max_rows=20)
    for row in r.data.get("rows", []):
        print(row)

if __name__ == "__main__":
    main()
