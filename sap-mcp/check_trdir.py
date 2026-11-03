import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings('GY7'))
    r = b.read_table("TFDIR", where_clause="FUNCNAME = 'Z_MCP_SEARCH'", fields=["FUNCNAME", "PNAME", "INCLUDE", "FMODE"])
    print("TFDIR for Z_MCP_SEARCH on GY7:")
    for row in r.data.get("rows", []):
        print(row)

if __name__ == "__main__":
    main()
