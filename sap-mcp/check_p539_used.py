import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
res = b.get_where_used("TABL", "PA0539")
print("Where used PA0539:", res.ok, res.message)
if res.data:
    for line in res.data[:30]:
        print(line)
