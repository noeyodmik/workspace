import io
import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

c = Connection(**Settings("EA3").rfc_params())

# 1. RFCDES에서 100_EY와 100_SD 확인
res = c.call("BBP_RFC_READ_TABLE",
    QUERY_TABLE="RFCDES",
    OPTIONS=[{"TEXT": "RFCDEST = '100_EY' OR RFCDEST = '100_SD'"}],
    FIELDS=[{"FIELDNAME": "RFCDEST"}, {"FIELDNAME": "RFCTYPE"}, {"FIELDNAME": "RFCOPTIONS"}]
)
print("=== RFCDES ===")
for r in res.get("DATA", []):
    print(" ", r["WA"].strip())

# 2. RFCDISPLAY에서 100_EY와 100_SD 호스트/포트/SSL 확인
for dest in ['100_EY', '100_SD']:
    try:
        r_disp = c.call("RFC_READ_HTTP_DESTINATION", DESTINATION=dest)
        print(f"\n=== RFC_READ_HTTP_DESTINATION: {dest} ===")
        print("  HOST:", r_disp.get("SERVER"))
        print("  PORT:", r_disp.get("PORT"))
        print("  PATH:", r_disp.get("PATHPREFIX"))
        print("  SSL:", r_disp.get("SSL"))
        print("  SSL_APPL:", r_disp.get("SSL_APPL"))
    except Exception as e:
        print(f"Error reading {dest}:", e)

