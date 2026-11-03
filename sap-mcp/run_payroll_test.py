import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.read_table("T001", where_clause="BUKRS = '1101'", fields=["BUKRS", "LAND1", "WAERS"])
    print("T001 1101:", r.data.get("rows"))

    print("=== RUNNING PAYROLL ===")
    res = b.run_payroll(pernr="53", test_run=True)
    print("OK:", res.ok)
    print("MESSAGE:", res.message)
    if res.data:
        print("RT count:", len(res.data.get("rt", [])))
        print("RT:", json.dumps(res.data.get("rt", []), indent=2, ensure_ascii=False))
        print("LOG summary:", json.dumps(res.data.get("log_summary", []), indent=2, ensure_ascii=False))
        print("Error messages:", json.dumps(res.data.get("error_messages", []), indent=2, ensure_ascii=False))
        print("Retro periods:", json.dumps(res.data.get("retro_periods", []), indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()
