import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T550A", where_clause="TPROG = 'EVSA'", fields=["MOTPR", "TPROG", "TPKLA", "SOLLZ", "TAGTY"], max_rows=10)
    print("T550A EVSA:", r.data.get("rows") if r.data else r.message)

if __name__ == "__main__":
    main()
