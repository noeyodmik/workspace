import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
with open("current_lzmcpu12.txt", "r", encoding="utf-8") as f:
    orig = f.read()

transport = "EA3K900019"
up = b.update_source("FUNC", "Z_MCP_RUN_PAYROLL", orig, transport)
print("Restore update:", up.ok, up.message)
act = b.activate_object("FUNC", "Z_MCP_RUN_PAYROLL")
print("Restore activate:", act.ok, act.message)
