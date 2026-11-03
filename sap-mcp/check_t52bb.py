import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T52BA", where_clause="SCHEM = 'TC00'", fields=["SCHEM", "LINFO"], max_rows=5)
    print("T52BA:", r.data.get("rows") if r.data else r.message)

    r_lines = b.read_table("T52BB", where_clause="SCHEM = 'TC00'", fields=["SCHEM", "SEQNO", "FUNCO", "PARM1", "PARM2"], max_rows=50)
    print("T52BB lines count:", len(r_lines.data.get("rows", [])) if r_lines.data else r_lines.message)
    if r_lines.data:
        for row in r_lines.data.get("rows", []):
            print(f"{row.get('SEQNO')}: {row.get('FUNCO')} {row.get('PARM1')} {row.get('PARM2')}")

if __name__ == "__main__":
    main()
