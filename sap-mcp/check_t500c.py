import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T500C", where_clause="LAND1 = 'KR'")
    print("T500C KR:", r.data.get("rows"))
    for bukrs in ["1101", "CUR1", "EYKR", "KR01", "Z000", "Z100"]:
        r_b = b.read_table("T001", where_clause=f"BUKRS = '{bukrs}'", fields=["BUKRS", "LAND1", "WAERS"])
        print(f"T001 {bukrs}:", r_b.data.get("rows"))

    print("=== T500P (MOLGA = 41) ===")
    r_p = b.read_table("T500P", where_clause="MOLGA = '41'")
    print("T500P (41):", json.dumps(r_p.data.get("rows", []), indent=2, ensure_ascii=False))

    print("=== T001P (MOLGA = 41) ===")
    r_1p = b.read_table("T001P", where_clause="MOLGA = '41'")
    print("T001P (41):", json.dumps(r_1p.data.get("rows", []), indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()
