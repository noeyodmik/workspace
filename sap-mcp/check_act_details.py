import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b._call("Z_MCP_ACTIVATE", IV_TYPE="FUNC", IV_NAME="Z_MCP_GET_REPLICATION_LOG")
print("Activate return:")
print(json.dumps(r, ensure_ascii=False, indent=2))
