import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T52C5", where_clause="CCYCL = 'TD00'", fields=["ABART", "CCYCL", "LGART", "SEQNO", "VARGT", "VINFO"], max_rows=30)
    print("T52C5 TD00 count:", len(r.data.get("rows", [])) if r.data else r.message)
    if r.data:
        abart_set = set(row.get("ABART") for row in r.data.get("rows", []))
        print("TD00 ABARTs:", abart_set)
        for row in r.data.get("rows", [])[:10]:
            print(f"{row.get('ABART')} {row.get('LGART')} {row.get('VARGT')}: {row.get('VINFO')}")

if __name__ == "__main__":
    main()
