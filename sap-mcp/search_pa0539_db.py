import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
for prog in ["MP053900", "MP053910", "MP053920", "MP053930", "MP053940", "P0002KR1", "P0002KR2", "P0002KR3", "P0002KR4"]:
    r = b.get_source("PROG", prog)
    if r.ok and r.data:
        for i, line in enumerate(r.data.splitlines()):
            if any(w in line.upper() for w in ["PA0539", "UPDATE_DATABASE", "PRE_LP_UPDATE", "POST_LP_UPDATE"]):
                print(f"{prog}:{i+1}: {line.strip()}")
