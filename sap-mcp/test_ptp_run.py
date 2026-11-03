import io
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    print('=== RP_HRSFEC_PTP_EE_REPLICATION 테스트 실행 (config_id: 9900_K0) ===')
    res = b.get_replication_log(trigger_replication=True, config_id="9900_K0", max_rows=30)
    print('OK:', res.ok)
    print('Message:', res.message)
    if res.ok and res.data:
        logs = res.data.get('logs', [])
        print(f'Logs count: {len(logs)}')
        for l in logs[:15]:
            print(f"[{l.get('msgty')}] {l.get('msgid')} {l.get('msgno')}: {l.get('message_text')} ({l.get('v1')} {l.get('v2')})")

if __name__ == "__main__":
    main()
