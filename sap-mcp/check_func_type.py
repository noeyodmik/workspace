import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    tf = b.read_table("TFDIR", where_clause="FUNCNAME = 'Z_MCP_ACTIVATE'", max_rows=5)
    inc = f"LZMCPU{tf.data['rows'][0]['INCLUDE']}"
    r = b.get_source("INCL", inc)
    dwin = b.read_table("DWINACTIV", where_clause="UNAME = 'DUSER03'", max_rows=10)
    print("DWINACTIV:", dwin.data.get("rows"))

if __name__ == "__main__":
    main()
