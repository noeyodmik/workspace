import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from backends.rfc_backend import RfcBackend
from config import Settings

b = RfcBackend(Settings())

r = b.read_table("ENLFDIR", where_clause="FUNCNAME LIKE 'Z_MCP_%'")
if r.ok:
    for row in r.data["rows"]:
        print(f"FM: {row.get('FUNCNAME')}, AREA: {row.get('AREA')}")
