import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
with b._conn() as c:
    r = c.call("RPY_PROGRAM_READ", PROGRAM_NAME="RP_HRSFEC_PTP_EE_REPLICATION")
    src = [line["LINE"] for line in r.get("SOURCE_EXTENDED", [])]
    for i in range(0, min(160, len(src))):
        print(f"{i+1:3d}: {src[i]}")
