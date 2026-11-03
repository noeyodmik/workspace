import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
src = b.get_source("PROG", "MP053900")
print("MP053900 ok:", src.ok, len(src.data) if src.ok and src.data else src.message)
if src.ok and src.data:
    for line in src.data[:60]:
        print(line)
