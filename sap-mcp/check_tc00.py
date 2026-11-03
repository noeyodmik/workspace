import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T52C1", where_clause="MOLGA = '41' AND SCHEM = 'TC00'", fields=["MOLGA", "SCHEM", "LINNO", "PFUNC", "PAR1", "PAR2", "PAR3", "PAR4"], max_rows=50)
    print("T52C1 count:", len(r.data.get("rows", [])) if r.data else 0)
    for row in r.data.get("rows", []):
        print(row)

if __name__ == "__main__":
    main()
