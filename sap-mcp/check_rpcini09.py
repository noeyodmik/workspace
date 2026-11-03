import io, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.get_source("PROG", "RPCINI09")
    if r.ok and r.data:
        src = r.data if isinstance(r.data, str) else r.data.get("source", "")
        print("RPCINI09 source length:", len(src))
        lines = src.splitlines()
        for i, l in enumerate(lines):
            if "T001P" in l or "RP_GET_CURRENCY" in l or "INIT_ERROR" in l:
                print(f"L{i+1}: {l}")
                for sub in lines[max(0, i-5):min(len(lines), i+15)]:
                    print(f"  {sub}")
                print("-" * 50)
    else:
        print("Failed to get RPCINI09:", r.message)

if __name__ == "__main__":
    main()
