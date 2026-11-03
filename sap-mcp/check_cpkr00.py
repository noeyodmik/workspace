import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.get_source("PROG", "%_CPKR00")
    if r.ok and r.data:
        src = r.data if isinstance(r.data, str) else r.data.get("source", "")
        lines = src.splitlines()
        print("%_CPKR00 lines:", len(lines))
        for i, l in enumerate(lines):
            if "DAYPR" in l or "TC00" in l:
                print(f"L{i+1}: {l}")
                for sub in lines[max(0, i-5):min(len(lines), i+20)]:
                    print("   ", sub)
                print("-" * 50)
    else:
        print("%_CPKR00 failed:", r.message)

if __name__ == "__main__":
    main()
