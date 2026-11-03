import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T52C1", where_clause="SCHEM = 'TC00'", fields=["MOLGA", "SCHEM", "LINNO", "PFUNC", "PAR1", "PAR2", "PAR3", "PAR4"], max_rows=50)
    print("T52C1 count:", len(r.data.get("rows", [])) if r.data else r.message)
    if r.data:
        for row in r.data.get("rows", []):
            print(f"{row.get('LINNO')}: {row.get('PFUNC')} {row.get('PAR1')} {row.get('PAR2')} {row.get('PAR3')}")

if __name__ == "__main__":
    main()
