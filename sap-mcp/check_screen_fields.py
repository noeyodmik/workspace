import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("D021S", where_clause="PROG = 'HKRCALC0' AND DYNR = '1000'", fields=["FNAM", "FLG1", "FLG2"], max_rows=50)
    print("Screen fields:", [row.get("FNAM") for row in r.data.get("rows", []) if row.get("FNAM")])

if __name__ == "__main__":
    main()
