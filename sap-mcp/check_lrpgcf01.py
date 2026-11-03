import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.get_source("INCL", "LRPGCF01")
    src = (r.data or "").split("\n")
    print(f"LRPGCF01 lines: {len(src)}")
    for i in range(124, 185):
        print(f"{i+1:3d}: {src[i]}")

if __name__ == "__main__":
    main()
