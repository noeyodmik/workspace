import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T100", where_clause="SPRSL = '3' AND ARBGB = 'PG' AND MSGNR = '628'")
    print("T100 PG628:", r.data.get("rows") if r.data else r.message)

if __name__ == "__main__":
    main()
