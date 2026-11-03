import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    # 1. 셀렉션 화면 파라미터 구조체 RSZSELECT
    for tbl in ["D020T", "D021T"]:
        r = b.read_table(tbl, where_clause="PROG = 'HKRCALC0'", max_rows=50)
        print(f"{tbl}: ok={r.ok}, count={len(r.data.get('rows', [])) if r.ok else 0}")
        if r.ok and r.data.get('rows'):
            for row in r.data['rows']:
                print("  ", row)

if __name__ == "__main__":
    main()
