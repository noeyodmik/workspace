import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T503", where_clause="PERSG = '1' AND PERSK = 'KR'")
    print("T503 (1/KR):", r.data.get("rows") if r.data else r.message)

if __name__ == "__main__":
    main()
