import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T001P", where_clause="WERKS = 'Z100' AND BTRTL = 'Z000'", fields=["WERKS", "BTRTL", "WKTYP", "MOZKO", "MOABW", "MOVER"])
    print("T001P Z100/Z000:", r.data.get("rows"))

if __name__ == "__main__":
    main()
