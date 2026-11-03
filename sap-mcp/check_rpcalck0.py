import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("D010INC", where_clause="MASTER = 'RPCALCK0'", fields=["INCLUDE"], max_rows=50)
    print("RPCALCK0 includes:", [row.get("INCLUDE") for row in r.data.get("rows", [])] if r.data else r.message)

if __name__ == "__main__":
    main()
