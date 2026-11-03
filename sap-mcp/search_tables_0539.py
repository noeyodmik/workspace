import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("DD02L", where_clause="TABNAME LIKE 'PA053%' OR TABNAME LIKE 'PB053%'", fields=["TABNAME", "TABCLASS"])
    print("DD02L tables:")
    for row in r.data.get("rows", []):
        print(row)

if __name__ == "__main__":
    main()
