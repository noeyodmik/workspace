import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    print("=== Triggering PTP Replication for 70000019 (Config: 100_EY) ===")
    res = b.get_replication_log(ext_id="70000019",
                                config_id="100_EY",
                                trigger_replication=True,
                                max_rows=50)
    print("Call OK:", res.ok)
    print("Message:", res.message)
    if res.data:
        headers = res.data.get("headers", [])
        messages = res.data.get("messages", [])
        print(f"\n[Headers] {len(headers)} 건")
        for h in headers[:5]:
            print(f"  Log No: {h.get('lognumber')}, Date: {h.get('date')} {h.get('time')}, Total: {h.get('total_msgs')}, Errors: {h.get('error_msgs')}")

        print(f"\n[Messages] {len(messages)} 건")
        for m in messages:
            print(f"  [{m.get('type')}] {m.get('id')} {m.get('number')}: {m.get('message')}")

    # 또한 HRSFEC_D_REPSTAT 상태도 함께 확인
    print("\n=== Checking Replication Status (HRSFEC_D_REPSTAT) ===")
    stat = b.get_replication_status(ext_id="70000019")
    print("Status OK:", stat.ok)
    print("Status Message:", stat.message)
    if stat.data:
        print("Status Data:", json.dumps(stat.data, ensure_ascii=False, indent=2))

if __name__ == "__main__":
    main()
