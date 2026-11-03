import io
import json
import sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def main():
    b = RfcBackend(Settings())
    tf = b.read_table("TFDIR", where_clause="FUNCNAME = 'HRCA_COMPANYCODE_GETDETAIL'", max_rows=5)
    print("TFDIR:", tf.data.get("rows"))
    pname = tf.data['rows'][0]['PNAME']
    inc = f"{pname}U{tf.data['rows'][0]['INCLUDE']}"
    r = b.get_source("INCL", "LRHCMU01")
    for l in (r.data or "").split("\n")[40:70]:
        print("  ", l)

if __name__ == "__main__":
    main()
