import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b._call("Z_MCP_RUN_PAYROLL", IV_PERNR="00000053", IV_TEST="X", IV_SCHEMA="KR00")
    raw_log = [line.get("LINE", "").rstrip() for line in r.get("ET_LOG", [])]
    
    # 마지막 100줄 출력
    print(f"Total log lines: {len(raw_log)}")
    for i, line in enumerate(raw_log):
        if any(w in line for w in ["오류", "거부", "Error", "Fehler", "No entry", "entry not found", "부재"]):
            print(f"[{i}] {line}")
            for sub in raw_log[max(0, i-5):min(len(raw_log), i+10)]:
                print(f"    {sub}")
            print("="*60)

    print("\n--- LAST 50 LINES ---")
    for l in raw_log[-50:]:
        print(l)

if __name__ == "__main__":
    main()
