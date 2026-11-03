import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
with b._conn() as c:
    r = c.call("Z_MCP_RUN_PAYROLL", IV_PERNR="00000053", IV_TEST="X", IV_SCHEMA="KR00")
    logs = [row["LINE"] for row in r.get("ET_LOG", [])]
    print(f"Total ET_LOG lines: {len(logs)}")
    for i, l in enumerate(logs):
        if any(k in l for k in ["1010", "/101", "/559", "/102", "기본급", "RT", "지급", "공제", "소득세", "국민연금", "건강보험", "고용보험"]):
            print(f"L{i+1}: {l}")

with open("payroll_full_log.txt", "w", encoding="utf-8") as f:
    for l in logs:
        f.write(l + "\n")
print("Full log written to payroll_full_log.txt")
