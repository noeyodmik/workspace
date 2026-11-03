import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.get_source("FUNC", "Z_MCP_ACTIVATE")
if r.ok and r.data:
    print(r.data)
else:
    print(r.message)
