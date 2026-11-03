import io
import json
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

with open("zmcp_exported_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

fn_data = data["functions"]["Z_MCP_SEARCH"]
params = fn_data["params"]
source = fn_data["source"]

print("Z_MCP_SEARCH first 3 lines:")
for l in source[:3]:
    print(" ", repr(l))
print("Z_MCP_SEARCH last 3 lines:")
for l in source[-3:]:
    print(" ", repr(l))

c = Connection(**config.Settings('GY7').rfc_params())

imp = []
exp = []
cha = []
tbl = []
exc = []

for p in params:
    pcl = p.get('PARAMCLASS')
    pname = p.get('PARAMETER')
    ptyp = p.get('TABNAME', '')
    popt = p.get('OPTIONAL', '')
    pdef = p.get('DEFAULTVAL', '')

    if pcl == 'I':
        imp.append({'PARAMETER': pname, 'TYP': ptyp, 'OPTIONAL': popt, 'DEFAULT': pdef, 'REFERENCE': 'X'})
    elif pcl == 'E':
        exp.append({'PARAMETER': pname, 'TYP': ptyp, 'REFERENCE': 'X'})
    elif pcl == 'C':
        cha.append({'PARAMETER': pname, 'TYP': ptyp, 'OPTIONAL': popt, 'DEFAULT': pdef, 'REFERENCE': 'X'})
    elif pcl == 'T':
        tbl.append({'PARAMETER': pname, 'DBSTRUCT': ptyp, 'OPTIONAL': popt})
    elif pcl == 'X':
        exc.append({'EXCEPTION': pname})

# FUNCTION, ENDFUNCTION 제거
body_lines = []
for l in source:
    stripped = l.strip().upper()
    if stripped.startswith("FUNCTION ") or stripped == "ENDFUNCTION.":
        continue
    body_lines.append({'LINE': l})

print(f"Prepared body: {len(body_lines)} lines")
print("Import:", imp)
print("Export:", exp)
print("Tables:", tbl)
print("Exceptions:", exc)

try:
    res = c.call('RS_FUNCTIONMODULE_INSERT',
                 FUNCTION_POOL='ZMCP',
                 FUNCNAME='Z_MCP_SEARCH',
                 SHORT_TEXT='Search Repository Objects',
                 REMOTE_CALL='X',
                 SAVE_ACTIVE='X',
                 SUPPRESS_CORR_CHECK='X',
                 IMPORT_PARAMETER=imp,
                 EXPORT_PARAMETER=exp,
                 CHANGING_PARAMETER=cha,
                 TABLES_PARAMETER=tbl,
                 EXCEPTION_LIST=exc,
                 SOURCE=body_lines)
    print("RS_FUNCTIONMODULE_INSERT success:", res)
except Exception as e:
    print("RS_FUNCTIONMODULE_INSERT error:", e)
