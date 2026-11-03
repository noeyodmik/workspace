import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("PA0002", where_clause="PERNR = '00000053'")
    print("PA0002:", json.dumps(r.data.get("rows", []), indent=2, ensure_ascii=False) if r.data else r.message)

if __name__ == "__main__":
    main()
