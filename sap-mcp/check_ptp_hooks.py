import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
with b._conn() as c:
    r = c.call("RPY_PROGRAM_READ", PROGRAM_NAME="RP_HRSFEC_PTP_EE_REPLICATION")
    src = [line["LINE"] for line in r.get("SOURCE_EXTENDED", [])]
    print(f"Total lines in RP_HRSFEC_PTP_EE_REPLICATION: {len(src)}")
    for i, l in enumerate(src):
        if any(k in l.upper() for k in ["BADI", "ENHANCEMENT", "END-OF-SELECTION", "SUBMIT"]):
            print(f"L{i+1}: {l.strip()}")
