import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
sys.stdout.reconfigure(encoding="utf-8")
from config import Settings
from backends.rfc_backend import RfcBackend

b = RfcBackend(Settings("GY7"))
conn = b._conn()

# ZHRT0100 전수 테스트 ABAP 스크립트 (각 라인 <= 72자)
abap = [
    "REPORT Z_TEST_ALL_PAYSLIP.",
    "DATA: lt_100 TYPE TABLE OF zhrt0100, ls_100 TYPE zhrt0100,",
    "      lt_slip TYPE TABLE OF zhrs0027_b3, ls_slip TYPE zhrs0027_b3,",
    "      lr_pernr TYPE RANGE OF pernr_d, ls_pernr LIKE LINE OF lr_pernr,",
    "      lr_paydt TYPE RANGE OF dats, ls_paydt LIKE LINE OF lr_paydt,",
    "      lr_orgeh TYPE cchrs_orgeh_range,",
    "      lv_err_cnt TYPE i, lv_ok_cnt TYPE i, lv_pdf_cnt TYPE i,",
    "      lv_pdf TYPE xstring, lv_fsize TYPE i, lv_ev_pdf TYPE xstring,",
    "      lv_yr TYPE char04.",
    "",
    "SELECT * FROM zhrt0100 INTO TABLE lt_100",
    "  ORDER BY pabrj DESCENDING pabrp DESCENDING pernr.",
    "",
    "WRITE: / '=== START ALL 77 ROWS TEST ==='.",
    "LOOP AT lt_100 INTO ls_100.",
    "  REFRESH: lr_pernr, lr_paydt, lt_slip.",
    "  CLEAR: ls_pernr, ls_paydt, lv_pdf, lv_fsize, lv_ev_pdf.",
    "  ls_pernr-sign = 'I'. ls_pernr-option = 'EQ'.",
    "  ls_pernr-low  = ls_100-pernr. APPEND ls_pernr TO lr_pernr.",
    "  ls_paydt-sign = 'I'. ls_paydt-option = 'EQ'.",
    "  ls_paydt-low  = ls_100-paydt. APPEND ls_paydt TO lr_paydt.",
    "  lv_yr         = ls_100-pabrj.",
    "",
    "  CALL FUNCTION 'ZHR0004_PRINT_PAYSLIP_PDF_B3T'",
    "    EXPORTING",
    "      IV_ZSTYPE   = ls_100-zstype",
    "      IV_YEAR     = lv_yr",
    "    IMPORTING",
    "      E_PDF_DATA  = lv_pdf",
    "      E_PDF_FSIZE = lv_fsize",
    "      EV_PDF      = lv_ev_pdf",
    "    TABLES",
    "      IR_PERNR    = lr_pernr",
    "      IR_PAYDT    = lr_paydt",
    "      IR_ORGEH    = lr_orgeh",
    "      ET_PAYSLIP  = lt_slip",
    "    EXCEPTIONS",
    "      OTHERS      = 99.",
    "  IF sy-subrc <> 0.",
    "    lv_err_cnt = lv_err_cnt + 1.",
    "    WRITE: / 'ERR PERNR:', ls_100-pernr, 'PAYDT:', ls_100-paydt,",
    "             'RC:', sy-subrc.",
    "  ELSE.",
    "    lv_ok_cnt = lv_ok_cnt + 1.",
    "    IF lv_fsize > 0 OR xstrlen( lv_pdf ) > 0.",
    "      lv_pdf_cnt = lv_pdf_cnt + 1.",
    "    ENDIF.",
    "    READ TABLE lt_slip INTO ls_slip INDEX 1.",
    "    IF sy-subrc = 0.",
    "      IF ls_100-ocrsn = '0007' OR ls_100-paydt = '20250305'.",
    "        WRITE: / 'SPEC:', ls_100-pernr, ls_100-paydt, ls_100-ocrsn,",
    "                 'C00:', ls_slip-calc00, 'C07:', ls_slip-calc07,",
    "                 'C10_1:', ls_slip-calc10_1, 'PDF_SZ:', lv_fsize.",
    "      ENDIF.",
    "    ENDIF.",
    "  ENDIF.",
    "ENDLOOP.",
    "WRITE: / '=== SUMMARY ==='.",
    "WRITE: / 'TOTAL:', lines( lt_100 ), 'OK:', lv_ok_cnt,",
    "         'ERR:', lv_err_cnt, 'PDF_OK:', lv_pdf_cnt.",
]

for i, ln in enumerate(abap):
    assert len(ln) <= 72, f"Line {i} too long ({len(ln)}): {ln}"

res = conn.call("RFC_ABAP_INSTALL_AND_RUN", PROGRAM=[{"LINE": ln} for ln in abap])
print("ERR:", res.get("ERRMESSAGE"))
for w in res.get("WRITES", []):
    print(w["ZEILE"].strip())

