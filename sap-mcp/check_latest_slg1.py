import io
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    res = b.get_replication_log(msgty='E', max_rows=10)
    print('OK:', res.ok, res.message)
    if res.ok and res.data:
        logs = res.data.get('logs', [])
        print(f'Total Error Logs returned: {len(logs)}')
        for l in logs[:10]:
            print(f"[{l.get('msgty')}] {l.get('msgid')} {l.get('msgno')} - {l.get('message_text')} | params: ({l.get('v1')} / {l.get('v2')})")

if __name__ == "__main__":
    main()
