import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T508A", where_clause="SCHKZ = 'NORM_EVS'", fields=["MOFID", "MOSID", "SCHKZ", "ENDDA", "BEGDA", "MOTPR", "MOTTY"])
    print("T508A NORM_EVS:", r.data.get("rows") if r.data else r.message)

    r_all = b.read_table("T508A", fields=["MOFID", "MOSID", "SCHKZ", "ENDDA", "BEGDA"], max_rows=15)
    print("T508A all sample:")
    for row in r_all.data.get("rows", []):
        print(row)

if __name__ == "__main__":
    main()
