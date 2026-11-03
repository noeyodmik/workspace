import io, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b.get_source("FUNC", "RP_GET_CURRENCY")
    if r.ok and r.data:
        src = r.data if isinstance(r.data, str) else r.data.get("source", "")
        print("RP_GET_CURRENCY:\n", src)
    else:
        print("Failed to get RP_GET_CURRENCY:", r.message)

if __name__ == "__main__":
    main()
