import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b._call("RPY_PROGRAM_READ", PROGRAM_NAME="SAPDBPNP")
    texts = r.get("TEXTELEMENTS", [])
    print(f"Total SAPDBPNP TEXTELEMENTS: {len(texts)}")
    for t in texts:
        if t.get("ID") == "S":
            entry = t.get("ENTRY", "")
            key = t.get("KEY", "")
            if any(k in entry for k in ["급여", "영역", "Payroll", "Area", "기간"]) or "ABKRS" in key:
                print(f"  {key}: {entry}")

if __name__ == "__main__":
    main()
