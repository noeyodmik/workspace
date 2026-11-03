import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.read_table("DWINACTIV", where_clause="OBJ_NAME LIKE '%LZMCP%' OR OBJ_NAME LIKE '%Z_MCP_RUN_PAYROLL%'")
print("DWINACTIV:", r.data.get("rows"))
