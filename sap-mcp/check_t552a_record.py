import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T552A", where_clause="SCHKZ = 'NORM_EVS' AND KJAHR = '2020' AND MONAT = '01'", fields=["KJAHR", "MONAT", "MOFID", "MOSID", "SCHKZ", "ZEITY"])
    print("T552A NORM_EVS 2020/01 ok:", r.ok)
    print("T552A rows:", r.data.get("rows") if r.data else r.message)

    r_all = b.read_table("T552A", where_clause="SCHKZ = 'NORM_EVS'", fields=["KJAHR", "MONAT", "MOFID", "MOSID", "SCHKZ", "ZEITY"], max_rows=10)
    print("T552A NORM_EVS all count:", len(r_all.data.get("rows", [])) if r_all.data else r_all.message)
    if r_all.data and r_all.data.get("rows"):
        for row in r_all.data.get("rows"):
            print("  ", row)

if __name__ == "__main__":
    main()
