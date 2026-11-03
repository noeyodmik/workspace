import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.get_source("INCL", "LZMCPU12")
    with open("current_lzmcpu12.txt", "w", encoding="utf-8") as f:
        f.write(r.data or "")
    print(f"Saved current_lzmcpu12.txt ({len(r.data or '')} bytes)")

if __name__ == "__main__":
    main()
