import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("DD03L", where_clause="TABNAME = 'T569V' AND FIELDNAME = 'STATE'")
    if r.data:
        print("DD03L:", r.data.get("rows"))
        rollname = r.data.get("rows")[0].get("ROLLNAME")
        domname = r.data.get("rows")[0].get("DOMNAME")
        print("ROLLNAME:", rollname, "DOMNAME:", domname)
        
        r_dom = b.read_table("DD07T", where_clause=f"DOMNAME = '{domname}'")
        for row in r_dom.data.get("rows", []):
            print(f"LANG: {row.get('DDLANGUAGE')} | VAL: {row.get('DOMVALUE_L')} | TEXT: {row.get('DDTEXT')}")

if __name__ == "__main__":
    main()
