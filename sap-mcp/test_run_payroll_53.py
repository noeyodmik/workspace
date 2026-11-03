import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def test():
    settings = Settings()
    backend = RfcBackend(settings)
    
    p1 = backend.read_table("PA0001", where_clause="PERNR = '00000053'", max_rows=5)
    print("PA0001 rows:", p1.data.get("rows"))
    pa03_res = backend.check_payroll_control_record(pernr="53")
    print(f"PA03 OK: {pa03_res.ok}")
    print(f"PA03 Message: {pa03_res.message}")
    print(f"PA03 Data: {json.dumps(pa03_res.data, ensure_ascii=False, indent=2)}")
    
    print("\n" + "=" * 60)
    print("2. 사원 53번 급여 계산 테스트 실행 (test_run=True)")
    print("=" * 60)
    pay_res = backend.run_payroll(pernr="53", test_run=True)
    print(f"Payroll OK: {pay_res.ok}")
    print(f"Payroll Message: {pay_res.message}")
    print(f"Payroll Data: {json.dumps(pay_res.data, ensure_ascii=False, indent=2)}")

if __name__ == "__main__":
    test()
