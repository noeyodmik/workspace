import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T001", where_clause="BUKRS = '1101'")
    row = r.data.get("rows", [])[0] if r.data.get("rows") else {}
    print("BUKRS 1101:", row.get("BUKRS"), row.get("BUTXT"), "LAND1:", repr(row.get("LAND1")), "WAERS:", row.get("WAERS"))
    
    r_z000 = b.read_table("T001", where_clause="BUKRS = 'Z000'")
    row_z = r_z000.data.get("rows", [])[0] if r_z000.data.get("rows") else {}
    print("BUKRS Z000:", row_z.get("BUKRS"), row_z.get("BUTXT"), "LAND1:", repr(row_z.get("LAND1")), "WAERS:", row_z.get("WAERS"))

if __name__ == "__main__":
    main()
