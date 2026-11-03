import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    res = b.get_replication_log(date_from="20261028", date_to="20261028", max_rows=100)
    print("Call OK:", res.ok)
    print("Message:", res.message)
    if res.data:
        headers = res.data.get("headers", [])
        messages = res.data.get("messages", [])
        print(f"\n[Headers] {len(headers)} 건")
        for h in headers:
            print(f"  Log No: {h.get('lognumber')}, Date: {h.get('date')} {h.get('time')}, Total: {h.get('total_msgs')}, Errors: {h.get('error_msgs')}, Ext: {h.get('extnumber')}")

        print(f"\n[Messages] {len(messages)} 건")
        for m in messages:
            print(f"  [{m.get('type')}] {m.get('id')} {m.get('number')}: {m.get('message')}")

if __name__ == "__main__":
    main()
