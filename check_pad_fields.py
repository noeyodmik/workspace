import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
OUT = r"c:\Users\sapin\Desktop\Workspace\out_check_pad_fields.txt"
c = Connection(**Settings("EA3").rfc_params())

r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE='DD03L', DELIMITER='|', ROWCOUNT=50,
           OPTIONS=[{'TEXT': "TABNAME = 'PAD_SFEC_DOUBLE_VALUE'"}],
           FIELDS=[{'FIELDNAME': f} for f in ['TABNAME', 'POSITION', 'FIELDNAME', 'ROLLNAME', 'DATATYPE', 'LENG', 'DECIMALS']])
rows = [d['WA'].strip() for d in r['DATA']]
txt = "== DD03L PAD_SFEC_DOUBLE_VALUE\n" + ("\n".join(rows) if rows else "(none)")
print(txt)
with open(OUT, "w", encoding="utf-8") as f:
    f.write(txt)
c.close()
