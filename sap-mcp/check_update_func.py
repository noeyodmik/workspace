import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    r = b._call("RPY_PROGRAM_READ", PROGRAM_NAME="LZMCPU03") # 또는 Z_MCP_UPDATE_SOURCE의 include
    # TFDIR에서 Z_MCP_UPDATE_SOURCE include 확인
    tf = b.read_table("TFDIR", where_clause="FUNCNAME = 'Z_MCP_UPDATE_SOURCE'", max_rows=5)
    print("TFDIR for UPDATE_SOURCE:", tf.data.get("rows"))
    inc = f"LZMCPU{tf.data['rows'][0]['INCLUDE']}"
    r2 = b.get_source("INCL", inc)
    print("Z_MCP_UPDATE_SOURCE first 30 lines:")
    for l in (r2.data or "").split("\n")[:35]:
        print("  ", l)

if __name__ == "__main__":
    main()
