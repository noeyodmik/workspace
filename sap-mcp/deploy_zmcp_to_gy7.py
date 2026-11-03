import io
import json
import sys
import config
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c_ea3 = Connection(**config.Settings('EA3').rfc_params())
c_gy7 = Connection(**config.Settings('GY7').rfc_params())

# 1. EA3에서 FUPARAREF 읽기
r_fupa = c_ea3.call('BBP_RFC_READ_TABLE', QUERY_TABLE='FUPARAREF',
                    OPTIONS=[{'TEXT': "FUNCNAME LIKE 'Z_MCP_%' AND R3STATE = 'A'"}],
                    DELIMITER='|',
                    FIELDS=[
                        {'FIELDNAME': 'FUNCNAME'},
                        {'FIELDNAME': 'PARAMETER'},
                        {'FIELDNAME': 'PARAMTYPE'},
                        {'FIELDNAME': 'STRUCTURE'},
                        {'FIELDNAME': 'DEFAULTVAL'},
                        {'FIELDNAME': 'REFERENCE'},
                        {'FIELDNAME': 'PPOSITION'},
                        {'FIELDNAME': 'OPTIONAL'},
                        {'FIELDNAME': 'TYPE'}
                    ])

fupa_by_fn = {}
for row in r_fupa.get('DATA', []):
    parts = [p.strip() for p in row.get('WA', '').split('|')]
    fn, param, ptype, struct, defval, ref, pos, opt, typ = (parts + ['']*9)[:9]
    fupa_by_fn.setdefault(fn, []).append({
        'PARAMETER': param,
        'PARAMTYPE': ptype,
        'STRUCTURE': struct,
        'DEFAULTVAL': defval,
        'REFERENCE': ref,
        'PPOSITION': int(pos) if pos.isdigit() else 0,
        'OPTIONAL': opt,
        'TYPE': typ
    })

with open("zmcp_exported_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

sorted_fns = sorted(data["functions"].keys(), key=lambda k: data["functions"][k].get("include", k))

for fn in sorted_fns:
    fn_info = data["functions"][fn]
    source = fn_info["source"]
    params = sorted(fupa_by_fn.get(fn, []), key=lambda x: x['PPOSITION'])

    imp, exp, cha, tbl, exc = [], [], [], [], []
    for p in params:
        pcl = p['PARAMTYPE']
        pname = p['PARAMETER']
        ptyp = p['STRUCTURE']
        popt = p['OPTIONAL']
        pdef = p['DEFAULTVAL']

        if pcl == 'I':
            imp.append({'PARAMETER': pname, 'TYP': ptyp, 'OPTIONAL': popt, 'DEFAULT': pdef, 'REFERENCE': ' '})
        elif pcl == 'E':
            exp.append({'PARAMETER': pname, 'TYP': ptyp, 'REFERENCE': ' '})
        elif pcl == 'C':
            cha.append({'PARAMETER': pname, 'TYP': ptyp, 'OPTIONAL': popt, 'DEFAULT': pdef, 'REFERENCE': ' '})
        elif pcl == 'T':
            tbl.append({'PARAMETER': pname, 'DBSTRUCT': ptyp, 'OPTIONAL': popt})
        elif pcl == 'X':
            exc.append({'EXCEPTION': pname})

    body_lines = []
    for l in source:
        stripped = l.strip().upper()
        if stripped.startswith("FUNCTION ") or stripped == "ENDFUNCTION." or stripped.startswith('*"'):
            continue
        body_lines.append(l)

    try:
        res = c_gy7.call('RS_FUNCTIONMODULE_INSERT',
                         FUNCTION_POOL='ZMCP',
                         FUNCNAME=fn,
                         SHORT_TEXT=f"MCP: {fn}",
                         REMOTE_CALL='X',
                         SAVE_ACTIVE='X',
                         SUPPRESS_CORR_CHECK='X',
                         NEW_SOURCE=body_lines,
                         IMPORT_PARAMETER=imp,
                         EXPORT_PARAMETER=exp,
                         CHANGING_PARAMETER=cha,
                         TABLES_PARAMETER=tbl,
                         EXCEPTION_LIST=exc)
        print(f"[OK] Created {fn} -> Include {res.get('FUNCTION_INCLUDE')}")
    except Exception as e:
        print(f"[INFO/ERR] {fn}: {e}")

# 2. Z_MCP_SEARCH (앞서 72자로 잘려 들어간 함수)를 Z_MCP_UPDATE_SOURCE + Z_MCP_ACTIVATE로 원복 및 전체 활성화
print("\n=== Updating Z_MCP_SEARCH full source & Activating all 12 FMs ===")
search_src = [{'LINE': l} for l in data["functions"]["Z_MCP_SEARCH"]["source"]]
r_upd = c_gy7.call('Z_MCP_UPDATE_SOURCE', IV_TYPE='FUNC', IV_NAME='Z_MCP_SEARCH', IV_TRANSPORT='', IT_SOURCE=search_src)
print("Update Z_MCP_SEARCH:", r_upd.get('EV_OK'), r_upd.get('EV_MESSAGE'))

for fn in sorted_fns:
    try:
        r_act = c_gy7.call('Z_MCP_ACTIVATE', IV_TYPE='FUNC', IV_NAME=fn)
        print(f"Activate {fn}: {r_act.get('EV_OK')} - {r_act.get('EV_MESSAGE')}")
    except Exception as e:
        print(f"Activate {fn} error: {e}")
