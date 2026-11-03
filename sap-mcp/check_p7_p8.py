import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r7 = b.read_table("PA0007", where_clause="PERNR = '00000053'")
    print("PA0007:", json.dumps(r7.data.get("rows", []), indent=2, ensure_ascii=False))

    r8 = b.read_table("PA0008", where_clause="PERNR = '00000053'")
    print("PA0008 ok:", r8.ok, "msg:", r8.message)
    if r8.data:
        print("PA0008 rows:", json.dumps(r8.data.get("rows", []), indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()
