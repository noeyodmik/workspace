import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.get_source("PROG", "RPCFUD00")
    if r.ok and r.data:
        src = r.data if isinstance(r.data, str) else r.data.get("source", "")
        lines = src.splitlines()
        print("RPCFUD00 lines:", len(lines))
        for i, l in enumerate(lines):
            if "DAYPR" in l or "LOHNARTENBILDUNG" in l or "Fehler" in l or "ERROR" in l.upper():
                print(f"L{i+1}: {l}")
                for sub in lines[max(0, i-3):min(len(lines), i+8)]:
                    print("   ", sub)
                print("-" * 50)
    else:
        print("RPCFUD00 failed:", r.message)

if __name__ == "__main__":
    main()
