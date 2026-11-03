import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    try:
        r = b._call("RP_GET_CURRENCY", MOLGA="41")
        print("RP_GET_CURRENCY result:", r)
    except Exception as e:
        print("RP_GET_CURRENCY exc:", e)
    t001 = b.read_table("T001", where_clause="BUKRS = 'Z100'", max_rows=5)
    print("T001:", t001.data.get("rows"))

if __name__ == "__main__":
    main()
