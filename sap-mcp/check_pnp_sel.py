import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b._call("RPY_PROGRAM_READ", PROGRAM_NAME="DBPNPSEL")
    src = [line.get("LINE", "") for line in r.get("SOURCE_EXTENDED", [])]
    print("=== DBPNPSEL matches for PNPXABKR, PYABKRS, PNPTIMR ===")
    for i, l in enumerate(src):
        if any(k in l for k in ["PNPXABKR", "PYABKRS", "PNPTIMR9", "PNPTIMR6", "PNPTIMRA"]):
            print(f"{i+1:3d}: {l}")

if __name__ == "__main__":
    main()
