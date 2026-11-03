import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.get_source("PROG", "MP000200")
for line in r.data.splitlines():
    if "INCLUDE" in line.upper():
        print(line.strip())
