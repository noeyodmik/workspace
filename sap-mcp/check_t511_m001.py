import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T511", where_clause="MOLGA = '41' AND LGART = 'M001'")
    print("T511 M001:", json.dumps(r.data.get("rows", []), indent=2, ensure_ascii=False) if r.data else r.message)

if __name__ == "__main__":
    main()
