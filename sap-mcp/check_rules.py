import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T52B3", where_clause="VAR = 'XMOD' OR VAR = 'KRM0'", fields=["MOLGA", "VAR", "MOPAR", "MOCON", "LINFO", "FPARA"], max_rows=50)
    print("T52B3 count:", len(r.data.get("rows", [])))
    for row in r.data.get("rows", []):
        print(row)

if __name__ == "__main__":
    main()
