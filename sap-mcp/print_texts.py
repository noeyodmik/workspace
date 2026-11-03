import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b._call("RPY_PROGRAM_READ", PROGRAM_NAME="HKRCALC0")
    texts = r.get("TEXTELEMENTS", [])
    print(f"Total TEXTELEMENTS: {len(texts)}")
    for t in texts:
        # print keys of t
        if t.get("ID") == "S" or t.get("TYPE") == "S" or "ID" not in t:
            # print all dict
            print(t)

if __name__ == "__main__":
    main()
