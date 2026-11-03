import io
import sys
from config import Settings
from backends.rfc_backend import RfcBackend

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
b = RfcBackend(Settings())
r = b.read_table("TFDIR", where_clause="FUNCNAME LIKE 'Z_MCP_%'", fields=["FUNCNAME"])
if not r.ok:
    print("read_table failed:", r.message)
else:
    funcs = [row["FUNCNAME"] for row in r.data.get("rows", [])]
    print(f"Total {len(funcs)} functions:")
    for f in sorted(funcs):
        print(" ", f)
