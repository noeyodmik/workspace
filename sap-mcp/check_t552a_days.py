import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T552A", where_clause="SCHKZ = 'NORM_EVS' AND KJAHR = '2020' AND MONAT = '01'", fields=["KJAHR", "MONAT", "TPR01", "TPR02", "TPR03", "FTK01", "FTK02", "FTK03"])
    print("T552A 2020/01 detail:", r.data.get("rows") if r.data else r.message)

if __name__ == "__main__":
    main()
