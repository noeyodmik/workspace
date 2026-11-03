import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())

# 1. Verify PA0539 & PA0540
r539 = b.read_table("PA0539", where_clause="PERNR = '00000053'", fields=["PERNR", "BEGDA", "ENDDA", "REGNO", "LNMHG", "FNMHG", "HSHLD"])
print("PA0539:", r539.ok, r539.data.get("rows") if r539.data else r539.message)

r540 = b.read_table("PA0540", where_clause="PERNR = '00000053'", fields=["PERNR", "BEGDA", "ENDDA", "REGNO", "LNMHG", "FNMHG", "FAMID"])
print("PA0540:", r540.ok, r540.data.get("rows") if r540.data else r540.message)

# 2. Run payroll simulation for 53
print("\n" + "=" * 60)
print("급여 계산 원격 실행 (HKRCALC0 / PC00_M41_CALC)")
print("=" * 60)

res = b.run_payroll(pernr="53", test_run=True)
print("OK:", res.ok)
print("Message:", res.message)
if res.data:
    print("\n--- Summary ---")
    print(f"사원: {res.data.get('pernr')}")
    print(f"급여 영역: {res.data.get('abkrs')} ({res.data.get('abkrs_text')})")
    print(f"계산 기간: {res.data.get('inper')} / {res.data.get('fpper')}")
    print(f"소급 여부: {res.data.get('is_retro')}")
    print(f"오류 여부: {res.data.get('has_error')}")
    print(f"RT 항목 수: {res.data.get('rt_count')}")
    print("\n--- RT (결과 테이블) ---")
    for row in res.data.get("rt", []):
        print(f"  임금유형: {row.get('lgart')}, 금액: {row.get('betrg'):,.0f} KRW, 수량: {row.get('anzhl')}")
    if res.data.get("has_error"):
        print("\n--- Error Messages ---")
        for err in res.data.get("error_messages", []):
            print(" ", err)
        print("\n--- Log Summary ---")
        for log in res.data.get("log_summary", [])[-30:]:
            print(" ", log)
