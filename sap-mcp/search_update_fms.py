import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
with b._conn() as c:
    r = c.call("RFC_FUNCTION_SEARCH", FUNCNAME="*PROGRAM*")
    for f in r.get("FUNCTIONS", []):
        fn = f.get("FUNCNAME")
        if any(k in fn for k in ["UPDATE", "MODIFY", "SAVE", "WRITE", "EDIT"]):
            print(fn)
