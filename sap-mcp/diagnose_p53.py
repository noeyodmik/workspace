import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    print("=== PA0000 ===")
    r0 = b.read_table("PA0000", where_clause="PERNR = '00000053'")
    print(json.dumps(r0.data.get("rows", []), indent=2, ensure_ascii=False))

    print("=== PA0001 ===")
    r1 = b.read_table("PA0001", where_clause="PERNR = '00000053'")
    p1_rows = r1.data.get("rows", [])
    print(json.dumps(p1_rows, indent=2, ensure_ascii=False))

    if p1_rows:
        row = p1_rows[0]
        werks = row.get("WERKS")
        btrtl = row.get("BTRTL")
        bukrs = row.get("BUKRS")
        print(f"Employee WERKS={werks}, BTRTL={btrtl}, BUKRS={bukrs}")
        
        print("=== T001P ===")
        rt001p = b.read_table("T001P", where_clause=f"WERKS = '{werks}' AND BTRTL = '{btrtl}'")
        print(json.dumps(rt001p.data.get("rows", []), indent=2, ensure_ascii=False))
        
        print("=== T001 ===")
        rt001 = b.read_table("T001", where_clause=f"BUKRS = '{bukrs}'")
        print(json.dumps(rt001.data.get("rows", []), indent=2, ensure_ascii=False))

        print("=== T500P ===")
        rt500p = b.read_table("T500P", where_clause=f"PERSA = '{werks}'")
        print(json.dumps(rt500p.data.get("rows", []), indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()
