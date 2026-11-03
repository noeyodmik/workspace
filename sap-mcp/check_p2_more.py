import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("PA0002", where_clause="PERNR = '00000053'", fields=["PERNR", "BEGDA", "ENDDA", "NACHN", "VORNA", "RUFNM", "PERID", "GBDAT"])
    print("PA0002:", json.dumps(r.data.get("rows", []), indent=2, ensure_ascii=False) if r.data else r.message)

    r2 = b.read_table("PA0002", where_clause="PERNR = '00000053'", fields=["INCO1", "LAND1", "NATIO", "PERID", "FAMST"])
    print("PA0002 (2):", json.dumps(r2.data.get("rows", []), indent=2, ensure_ascii=False) if r2.data else r2.message)

if __name__ == "__main__":
    main()
