import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
sys.stdout.reconfigure(encoding="utf-8")
from config import Settings
from backends.rfc_backend import RfcBackend

b = RfcBackend(Settings("GY7"))
conn = b._conn()

# ZHRT0100 전수 계산 검증 (정확한 시그니처, 각 라인 <= 72자)
abap = [
    "REPORT Z_TEST_77_CALC.",
    "DATA: lt_100 TYPE TABLE OF zhrt0100, ls_100 TYPE zhrt0100,",
    "      lt_slip TYPE TABLE OF zhrs0027_b3, ls_slip TYPE zhrs0027_b3,",
    "      lr_pernr TYPE TABLE OF sel_pernr WITH HEADER LINE,",
    "      lr_paydt TYPE TABLE OF sel_date  WITH HEADER LINE,",
    "      lr_orgeh TYPE TABLE OF cchrs_orgeh_range WITH HEADER LINE,",
    "      lv_cnt TYPE i, lv_ok TYPE i, lv_err TYPE i.",
    "",
    "SELECT * FROM zhrt0100 INTO TABLE lt_100",
    "  ORDER BY pabrj DESCENDING pabrp DESCENDING pernr.",
    "",
    "WRITE: / '=== START 77 DATA CALCULATION TEST ==='.",
    "LOOP AT lt_100 INTO ls_100.",
    "  REFRESH: lr_pernr, lr_paydt, lr_orgeh, lt_slip.",
    "  CLEAR: ls_slip, lv_cnt.",
    "  lr_pernr-sign = 'I'. lr_pernr-option = 'EQ'.",
    "  lr_pernr-low  = ls_100-pernr. APPEND lr_pernr.",
    "  lr_paydt-sign = 'I'. lr_paydt-option = 'EQ'.",
    "  lr_paydt-low  = ls_100-paydt. APPEND lr_paydt.",
    "",
    "  PERFORM get_payslip_data_b3 IN PROGRAM saplzhr0004_t",
    "    TABLES lr_pernr lr_paydt lr_orgeh lt_slip",
    "    USING  ls_100-zstype ' ' ls_100-pabrj",
    "    CHANGING lv_cnt.",
    "",
    "  READ TABLE lt_slip INTO ls_slip INDEX 1.",
    "  IF sy-subrc = 0.",
    "    lv_ok = lv_ok + 1.",
    "    WRITE: / ls_100-pernr, ls_100-pabrj, ls_100-pabrp, ls_100-ocrsn,",
    "             'C00:', ls_slip-calc00, 'C07:', ls_slip-calc07,",
    "             'C10_1:', ls_slip-calc10_1, 'C08:', ls_slip-calc08,",
    "             'T01:', ls_slip-tim01, 'T04:', ls_slip-tim04.",
    "  ELSE.",
    "    lv_err = lv_err + 1.",
    "    WRITE: / 'NO_DATA:', ls_100-pernr, ls_100-paydt, ls_100-zstype.",
    "  ENDIF.",
    "ENDLOOP.",
    "WRITE: / '=== SUMMARY ==='.",
    "WRITE: / 'TOTAL:', lines( lt_100 ), 'OK:', lv_ok, 'NO_DATA:', lv_err.",
]

for i, ln in enumerate(abap):
    assert len(ln) <= 72, f"Line {i} too long ({len(ln)}): {ln}"

res = conn.call("RFC_ABAP_INSTALL_AND_RUN", PROGRAM=[{"LINE": ln} for ln in abap])
print("ERR:", res.get("ERRMESSAGE"))
for w in res.get("WRITES", []):
    print(w["ZEILE"].strip())
