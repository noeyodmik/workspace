import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def test():
    settings = Settings()
    backend = RfcBackend(settings)
    
    t_res = backend.read_table('T549T', where_clause="ABKRS = 'K0'", max_rows=10)
    print("T549T 결과:", t_res.data)
    
    print("=" * 60)
    print("1. 사원번호 53번으로 급여 계산 실행 시도 (PA03 레코드 삭제 상태)")
    print("=" * 60)
    res1 = backend.run_payroll(pernr="53", test_run=True)
    print(f"결과 ok: {res1.ok}")
    print(f"메시지:\n{res1.message}")
    print(f"데이터: {json.dumps(res1.data, ensure_ascii=False, indent=2)}")
    
    print("\n" + "=" * 60)
    print("2. 급여영역 'K0'로 급여 계산 실행 시도 (PA03 레코드 삭제 상태)")
    print("=" * 60)
    res2 = backend.run_payroll(abkrs="K0", test_run=True)
    print(f"결과 ok: {res2.ok}")
    print(f"메시지:\n{res2.message}")
    print(f"데이터: {json.dumps(res2.data, ensure_ascii=False, indent=2)}")

if __name__ == "__main__":
    test()
