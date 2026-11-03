import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
for fn in ["RS_PROGRAM_SAVE", "RPY_PROGRAM_INSERT", "RPY_PROGRAM_UPDATE", "PREPARE_INCLUDE"]:
    print(fn, "remote:", b.is_remote_enabled(fn))
