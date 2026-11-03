import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.get_source("PROG", "RPCZKRN0")
    if r.ok and r.data:
        src = r.data if isinstance(r.data, str) else r.data.get("source", "")
        lines = src.splitlines()
        print("RPCZKRN0 lines:", len(lines))
        for i, l in enumerate(lines):
            if "539" in l or "KRSIP" in l:
                print(f"L{i+1}: {l}")
                for sub in lines[max(0, i-3):min(len(lines), i+15)]:
                    print("   ", sub)
                print("-" * 50)
    else:
        print("RPCZKRN0 failed:", r.message)

if __name__ == "__main__":
    main()
