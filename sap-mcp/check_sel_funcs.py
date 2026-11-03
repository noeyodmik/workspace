import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    # RS_SELECTIONSCREEN_INFO 또는 RS_VARIANT_CONTENTS
    for fn in ["RS_SELECTIONSCREEN_INFO", "RS_VARIANT_CONTENTS", "RS_PROGRAM_INDEX"]:
        chk = b.check_function_module(fn)
        print(f"{fn} rfc-enabled: {chk.ok}")

if __name__ == "__main__":
    main()
