import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T52C1", where_clause="SCHEM = 'TC00'", fields=["SCHEM", "SEQNO", "FUNCO", "PARM1", "PARM2", "PARM3", "PARM4"], max_rows=60)
    print("T52C1 TC00 rows:")
    for row in r.data.get("rows", []):
        print(f"{row.get('SEQNO')}: {row.get('FUNCO')} {row.get('PARM1')} {row.get('PARM2')} {row.get('PARM3')} {row.get('PARM4')}")

if __name__ == "__main__":
    main()
