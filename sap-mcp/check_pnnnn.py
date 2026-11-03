import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T582A", where_clause="INFTY = '0544' OR INFTY = '0540' OR INFTY = '0002'", fields=["INFTY", "PNNNN", "DNAME", "EDYNR"])
    print("T582A rows:")
    for row in r.data.get("rows", []):
        print(row)

if __name__ == "__main__":
    main()
