import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T001P", where_clause="WERKS = 'Z100' AND BTRTL = 'Z000'")
    row = r.data.get("rows", [])[0] if r.data.get("rows") else {}
    for k, v in row.items():
        if k.startswith("MO"):
            print(f"{k} = {v}")

if __name__ == "__main__":
    main()
