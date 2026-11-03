import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    # RPY_PROGRAM_READ 함수 모듈로 소스코드 읽기
    with open("../abap/zmcp/z_mcp_run_payroll.txt", "r", encoding="utf-8") as f:
        abap_code = f.read()
    
    chk = b.syntax_check("FUGR", "Z_MCP_PAYROLL", abap_code)
    print("Syntax check:", chk.ok, chk.message, chk.data)
    
    # 2. TADIR 또는 PROGDIR
    res2 = b.read_table("PROGDIR", where_clause="NAME = 'HKRCALC0'", max_rows=5)
    print("PROGDIR:", res2.data.get("rows"))

if __name__ == "__main__":
    main()
