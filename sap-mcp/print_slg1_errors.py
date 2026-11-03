import io
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    res = b.get_replication_log(max_rows=10)
    for m in res.data.get('messages', []):
        if m.get('type') in ('E', 'W'):
            print(f"[{m.get('type')}] {m.get('id')} {m.get('number')}: {m.get('message')}")

if __name__ == "__main__":
    main()
