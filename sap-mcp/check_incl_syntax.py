import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
r = b.get_source("INCL", "LZMCPU11")
chk = b.syntax_check("INCL", "LZMCPU11", r.data)
print("Syntax check INCL:", chk.ok, chk.message, chk.messages)
