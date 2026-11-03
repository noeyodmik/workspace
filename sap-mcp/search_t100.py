import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings('GY7'))
    r = b.read_table("T100", where_clause="ARBGB = 'FL' AND MSGNR = '651'", fields=["SPRSL", "ARBGB", "MSGNR", "TEXT"])
    print("T100 result:", r.data)

if __name__ == "__main__":
    main()
