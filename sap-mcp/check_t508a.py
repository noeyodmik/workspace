import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T508A", where_clause="SCHKZ = 'NORM_EVS'", fields=["MOFID", "MOSID", "SCHKZ", "ZTERF"], max_rows=10)
    print("T508A (NORM_EVS):", r.data.get("rows") if r.data else r.message)

    r_all = b.read_table("T508A", max_rows=20, fields=["MOFID", "MOSID", "SCHKZ", "ZTERF"])
    print("T508A sample:", r_all.data.get("rows") if r_all.data else r_all.message)

if __name__ == "__main__":
    main()
