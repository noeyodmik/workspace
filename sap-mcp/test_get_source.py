import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    for name in ["LZMCPU12", "SAPLZMCPU12", "SAPLZMCP"]:
        r = b.get_source("INCL", name)
        if not r.ok:
            r = b.get_source("PROG", name)
        print(f"get_source {name}: ok={r.ok}, len={len(r.data or '')}, msg={r.message}")
        if r.ok and len(r.data or "") > 0:
            lines = r.data.split("\n")
            print("First 5 lines:")
            for l in lines[:5]:
                print("  ", l)

if __name__ == "__main__":
    main()
