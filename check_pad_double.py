import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
OUT = r"c:\Users\sapin\Desktop\Workspace\out_check_pad_double.txt"
c = Connection(**Settings("EA3").rfc_params())
lines = []

def q(tab, fields, opts, rows=50):
    r = c.call('BBP_RFC_READ_TABLE', QUERY_TABLE=tab, DELIMITER='|', ROWCOUNT=rows,
               OPTIONS=[{'TEXT': o} for o in opts],
               FIELDS=[{'FIELDNAME': f} for f in fields])
    return [d['WA'].strip() for d in r['DATA']]

def section(title, rows):
    lines.append("== " + title)
    lines.extend(rows if rows else ["(none)"])

section("DD04L PAD_SFEC_DOUBLE_VALUE",
        q('DD04L', ['ROLLNAME', 'AS4LOCAL', 'DOMNAME', 'DATATYPE', 'LENG', 'DECIMALS', 'REFKIND', 'REFTYPE'],
          ["ROLLNAME = 'PAD_SFEC_DOUBLE_VALUE'"]))
section("DD01L domain of that element",
        q('DD01L', ['DOMNAME', 'DATATYPE', 'LENG', 'DECIMALS'],
          ["DOMNAME LIKE 'PAD_SFEC_DOUBLE%'"]))
section("DD03L PAYCOMPVALUE components",
        q('DD03L', ['TABNAME', 'FIELDNAME', 'ROLLNAME', 'DATATYPE', 'LENG', 'DECIMALS', 'COMPTYPE'],
          ["FIELDNAME = 'PAYCOMPVALUE'"]))
section("DD03L P0008 BET01",
        q('DD03L', ['TABNAME', 'FIELDNAME', 'ROLLNAME', 'DATATYPE', 'LENG', 'DECIMALS'],
          ["TABNAME = 'PA0008' AND FIELDNAME = 'BET01'"]))

txt = "\n".join(lines)
print(txt)
with open(OUT, "w", encoding="utf-8") as f:
    f.write(txt)
c.close()
