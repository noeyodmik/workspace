import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T588M", where_clause="DYNNR = '2000' AND ( PROG = 'MP000200' OR PROG = 'MP053900' )")
    print("T588M:")
    if r.data:
        for row in r.data.get("rows", []):
            print(row)
    else:
        print(r.message)

if __name__ == "__main__":
    main()
