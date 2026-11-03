import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T582A", where_clause="INFTY = '0539'")
    print("T582A for 0539:")
    if r.data:
        for row in r.data.get("rows", []):
            print(f"PNNNN: {row.get('PNNNN')}, ZWECK: {row.get('ZWECK')}, DTIMG: {row.get('DTIMG')}, CNTRG: {row.get('CNTRG')}")

if __name__ == "__main__":
    main()
