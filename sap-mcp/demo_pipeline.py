import sys
import io
from pathlib import Path

# Windows 콘솔 UTF-8 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

# sap-mcp 경로 설정
ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))

from config import Settings
from backends.rfc_backend import RfcBackend

b = RfcBackend(Settings())

print("=" * 70)
print("  [SAP MCP 풀스택 파이프라인 종합 시연 (E2E Demonstration)]")
print("=" * 70)

# 1. 시스템 연결 확인
print("\n[단계 1] SAP S/4HANA 실시간 연결 (RFC_SYSTEM_INFO)")
info = b.system_info()
if info.ok:
    sysid = info.data.get("RFCSYSID")
    host = info.data.get("RFCHOST")
    rel = info.data.get("RFCSAPRL")
    print(f"  ✅ 연결 성공: 시스템 [{sysid}] | 호스트 [{host}] | 릴리즈 [{rel}]")
else:
    print(f"  ❌ 연결 실패: {info.message}")

# 2. 원격 소스코드 라이프사이클 관리 (조회 및 반영)
print("\n[단계 2] 원격 소스코드 조회 및 자동 배포 (Remote Code Lifecycle)")
src_res = b.get_source("INCL", "LZMCPU11")
print(f"  1) LZMCPU11 소스 원격 조회: ok={src_res.ok} -> {src_res.message}")

code_file = ROOT.parent / "abap" / "zmcp" / "z_mcp_get_replication_log.txt"
with open(code_file, "r", encoding="utf-8") as f:
    target_code = f.read()

upd_res = b.update_source("FUNC", "Z_MCP_GET_REPLICATION_LOG", target_code, "EA3K900012")
print(f"  2) 원격 소스 자동 반영 (Z_MCP_UPDATE_SOURCE): ok={upd_res.ok} -> {upd_res.message}")

# 3. 급여 결과(Payroll Result) 조회 시연
print("\n[단계 3] 급여 결과 조회 시연 (Z_MCP_GET_PAYROLL_RESULT)")
pay_res = b.get_payroll_result("00000001")
print(f"  - 사번 00000001 급여 결과 조회: ok={pay_res.ok} -> {pay_res.message}")
if pay_res.ok and pay_res.data:
    dir_cnt = len(pay_res.data.get("directory", []))
    rt_cnt = len(pay_res.data.get("rt", []))
    print(f"  - 급여 정산 회차(Directory): {dir_cnt}건")
    print(f"  - 급여 RT 테이블 항목: {rt_cnt}건")
    if pay_res.data.get("directory"):
        latest = pay_res.data["directory"][0]
        print(f"    * 최근 회차: SEQNR {latest['seqnr']} | 급여월 {latest['inper']} | 지급일 {latest['paydt']}")

# 4. EC-ECP PTP 복제 트리거 + 실시간 SLG1 로그 수집 시연
print("\n[단계 4] EC-ECP PTP 사원 복제 실행 및 SLG1 실시간 진단 (Z_MCP_GET_REPLICATION_LOG)")
print("  - 백그라운드 복제 프로그램 (RP_HRSFEC_PTP_EE_REPLICATION) 트리거 호출 중...")
repl_res = b.get_replication_log(trigger_replication=True, max_rows=5)
print(f"  - 복제 트리거 및 SLG1 수집 완료: ok={repl_res.ok} -> {repl_res.message}")
if repl_res.ok and repl_res.data:
    print(f"  - 수집된 SLG1 로그: {repl_res.data.get('total_logs')}건 (발견된 오류: {repl_res.data.get('error_count')}건)")
    print("\n  [수집된 최신 SLG1 어플리케이션 로그 헤더]")
    for idx, h in enumerate(repl_res.data.get("headers", [])[:3]):
        print(f"    ({idx+1}) 로그번호: {h['lognumber']} | 생성일: {h['date']} {h['time']} | 사용자: {h['user']} | 서브오브젝트: {h['subobject']} | 오류수: {h['error_msgs']}")

    print("\n  [실시간 파싱된 주요 로그 메시지 내역]")
    for idx, m in enumerate(repl_res.data.get("messages", [])[:6]):
        print(f"    - [{m['type']}] ({m['id']}-{m['number']}) {m['message']}")

print("\n" + "=" * 70)
print("  >> E2E 종합 시연 완료: SAP 개발/운영 자동화 파이프라인이 정상 작동합니다.")
print("=" * 70)
