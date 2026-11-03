import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("PA0539", max_rows=10)
    print("PA0539 all count:", len(r.data.get("rows", [])) if r.data else r.message)
    if r.data:
        for row in r.data.get("rows", []):
            print(row)

if __name__ == "__main__":
    main()
