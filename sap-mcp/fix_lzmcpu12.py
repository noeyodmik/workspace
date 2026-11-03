import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
with open("c:/Users/sapin/Desktop/Workspace/abap/zmcp/z_mcp_run_payroll.txt", "r", encoding="utf-8") as f:
    clean_lines = [{"LINE": line} for line in f.read().splitlines()]

with b._conn() as c:
    try:
        r = c.call("RPY_PROGRAM_INSERT",
                   PROGRAM_NAME="LZMCPU12",
                   TITLE_STRING="Z_MCP_RUN_PAYROLL",
                   PROGRAM_TYPE="I",
                   DEVELOPMENT_CLASS="ZHRD",
                   TRANSPORT_NUMBER="EA3K900019",
                   SUPPRESS_DIALOG="X",
                   SAVE_INACTIVE=" ",
                   SOURCE_EXTENDED=clean_lines)
        print("RPY_PROGRAM_INSERT LZMCPU12:", r.get("PROGRAM_NAME"))
    except Exception as e:
        print("RPY_PROGRAM_INSERT error:", e)
