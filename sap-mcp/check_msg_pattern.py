import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T100", where_clause="SPRSL = '3' AND TEXT LIKE '%기간에 대한%인포%레코드가%'", fields=["SPRSL", "ARBGB", "MSGNR", "TEXT"])
    print("T100 messages:")
    for row in r.data.get("rows", []):
        print(row)

if __name__ == "__main__":
    main()
