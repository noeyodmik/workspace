import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T512W", where_clause="MOLGA = '41' AND LGART = 'M001'", fields=["MOLGA", "LGART"], max_rows=5)
    print("T512W M001:", r.data.get("rows") if r.data else r.message)

    for lg in ["M001", "M021", "M031", "M041", "M051"]:
        r_lg = b.read_table("T511", where_clause=f"MOLGA = '41' AND LGART = '{lg}'", fields=["MOLGA", "LGART"])
        print(f"T511 {lg}:", r_lg.data.get("rows") if r_lg.data else r_lg.message)

if __name__ == "__main__":
    main()
