import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("DOKTL", where_clause="OBJECT LIKE '%LOHNARTENBILDUNG%'", max_rows=5)
    print("DOKTL:", r.data.get("rows") if r.data else r.message)

if __name__ == "__main__":
    main()
