import io
import json
import sys
from pathlib import Path
import config
from pyrfc import Connection
import server

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c_gy7 = Connection(**config.Settings('GY7').rfc_params())

out_dir = Path("gy7_zhrpyr0017_b3_af_src")
out_dir.mkdir(exist_ok=True)

# 1. ZHRPYR0017_B3_AF 및 하위 Include 조회
progs = [
    "ZHRPYR0017_B3_AF",
    "ZHRPYR0017_B3_AF_TOP",
    "ZHRPYR0017_B3_AF_SEL",
    "ZHRPYR0017_B3_AF_O01",
    "ZHRPYR0017_B3_AF_I01",
    "ZHRPYR0017_B3_AF_F01",
]

for p in progs:
    res = server.read_source(p, obj_type="PROG", system="GY7")
    if res["ok"]:
        src = res["data"]["source"]
        (out_dir / f"{p}.abap").write_text(src, encoding="utf-8")
        print(f"[OK] Saved {p}.abap ({res['data']['line_count']} lines, author={res['data']['author']})")
    else:
        print(f"[ERR] {p}: {res['message']}")

# 2. ZHR0004_PRINT_PAYSLIP_PDF_B3AF 및 함수그룹 ZHR0004F03 전체 Include 조회
res_fn = server.read_source("ZHR0004_PRINT_PAYSLIP_PDF_B3AF", obj_type="FUNC", system="GY7")
if res_fn["ok"]:
    (out_dir / "ZHR0004_PRINT_PAYSLIP_PDF_B3AF.abap").write_text(res_fn["data"]["source"], encoding="utf-8")
    print(f"[OK] Saved ZHR0004_PRINT_PAYSLIP_PDF_B3AF.abap ({res_fn['data']['line_count']} lines)")

# SAPLZHR0004F03 및 LZHR0004F03* Include 목록 조회
r_inc = c_gy7.call('BBP_RFC_READ_TABLE', QUERY_TABLE='TRDIR',
                   OPTIONS=[{'TEXT': "NAME LIKE 'LZHR0004F03%' OR NAME = 'SAPLZHR0004F03'"}],
                   FIELDS=[{'FIELDNAME': 'NAME'}, {'FIELDNAME': 'CNAM'}, {'FIELDNAME': 'UNAM'}])
for row in r_inc.get('DATA', []):
    wa = row.get('WA', '')
    inc_name = wa[:40].strip()
    print(f"Found FUGR Include: {wa}")
    res_inc = server.read_source(inc_name, obj_type="INCL", system="GY7")
    if res_inc["ok"]:
        (out_dir / f"{inc_name}.abap").write_text(res_inc["data"]["source"], encoding="utf-8")
        print(f"  -> Saved {inc_name}.abap ({res_inc['data']['line_count']} lines)")

