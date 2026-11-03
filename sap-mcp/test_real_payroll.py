import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())

print("=" * 60)
print("실제 급여 계산 실행 (test_run=False) -> PCL2 결과 저장 및 RT 조회")
print("=" * 60)

res = b.run_payroll(pernr="53", test_run=False)
print("OK:", res.ok)
print("Message:", res.message)
if res.data:
    print(f"사원: {res.data.get('pernr')}")
    print(f"순번(SEQNR): {res.data.get('seqnr')}")
    print(f"귀속기간(FPPER): {res.data.get('fpper')}")
    print(f"지급기간(INPER): {res.data.get('inper')}")
    print(f"소급여부: {res.data.get('is_retro')}")
    print(f"RT 항목 수: {res.data.get('rt_count')}")
    print("\n--- 산출된 임금 유형 (RT) ---")
    for row in res.data.get("rt", []):
        print(f"  [{row.get('lgart')}] 금액: {row.get('betrg'):>12,.0f} KRW  (수량: {row.get('anzhl')})")
