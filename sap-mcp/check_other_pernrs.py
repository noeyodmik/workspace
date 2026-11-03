import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("PA0001", fields=["PERNR", "SNAME", "ABKRS", "WERKS", "BTRTL", "BEGDA"], max_rows=10)
    print("PA0001 sample employees:")
    for row in r.data.get("rows", []):
        print(row)

if __name__ == "__main__":
    main()
