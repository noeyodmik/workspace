import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())
for inc in ["MP053910", "MP053920", "MP053930", "MP053940"]:
    src = b.get_source("PROG", inc)
    if src.ok and src.data:
        text = src.data if isinstance(src.data, str) else "\n".join(src.data)
        print(f"=== {inc} ({len(text)} chars) ===")
        # search for INSERT or MODIFY or UPDATE or COMMIT
        for line in text.splitlines():
            if any(w in line.upper() for w in ["INSERT", "UPDATE", "MODIFY", "PRE_UPDATE", "POST_UPDATE", "TABLES", "P0539", "PA0539"]):
                print("  ", line.strip())
