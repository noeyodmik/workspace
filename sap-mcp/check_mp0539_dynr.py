import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("D020S", where_clause="PROG = 'MP053900'", fields=["PROG", "DNUM", "TYPE"])
    print("MP053900 dynpros:")
    if r.data:
        for row in r.data.get("rows", []):
            print(row)
    else:
        print(r.message)

if __name__ == "__main__":
    main()
