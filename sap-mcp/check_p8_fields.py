import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r8 = b.read_table("PA0008", where_clause="PERNR = '00000053'", fields=["PERNR", "BEGDA", "ENDDA", "TRFAR", "TRFGB", "TRFGR", "TRFST", "LGA01", "BET01", "LGA02", "BET02"])
    print("PA0008 ok:", r8.ok, "msg:", r8.message)
    print("PA0008 data:", r8.data.get("rows") if r8.data else None)

if __name__ == "__main__":
    main()
