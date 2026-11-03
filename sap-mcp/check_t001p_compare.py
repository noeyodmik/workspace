import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T001P", where_clause="WERKS = 'KR01' OR WERKS = 'EY01' OR WERKS = 'CUR1'")
    for row in r.data.get("rows", []):
        print(f"WERKS: {row.get('WERKS')}, BTRTL: {row.get('BTRTL')}, MOTAT: {repr(row.get('MOTAT'))}, MOABW: {repr(row.get('MOABW'))}, MOZKO: {repr(row.get('MOZKO'))}, MOVER: {repr(row.get('MOVER'))}")

if __name__ == "__main__":
    main()
