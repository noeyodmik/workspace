import sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
sys.stdout.reconfigure(encoding="utf-8")
from config import Settings
from backends.rfc_backend import RfcBackend

b = RfcBackend(Settings("GY7"))
conn = b._conn()

abap = [
    "REPORT Z_TEST_PDF_REPS.",
    "DATA: lr_pernr TYPE TABLE OF sel_pernr WITH HEADER LINE,",
    "      lr_paydt TYPE TABLE OF sel_date WITH HEADER LINE,",
    "      lr_orgeh TYPE TABLE OF cchrs_orgeh_range WITH HEADER LINE,",
    "      lv_pdf TYPE xstring, lv_fsize TYPE i.",
    "DATA: BEGIN OF ls_case,",
    "        title  TYPE string,",
    "        pernr  TYPE pernr_d,",
    "        paydt  TYPE dats,",
    "        zstype TYPE zstype,",
    "        year   TYPE char04,",
    "      END OF ls_case,",
    "      lt_case LIKE TABLE OF ls_case.",
    "",
    "START-OF-SELECTION.",
    "  ls_case-title = '1. 퇴직정산 OCRSN=0007'.",
    "  ls_case-pernr = '20250919'. ls_case-paydt = '20261028'.",
    "  ls_case-zstype = '400'. ls_case-year = '2026'.",
    "  APPEND ls_case TO lt_case.",
    "",
    "  ls_case-title = '2. 2025.03.05 연차보상'.",
    "  ls_case-pernr = '20250919'. ls_case-paydt = '20250305'.",
    "  ls_case-zstype = '100'. ls_case-year = '2025'.",
    "  APPEND ls_case TO lt_case.",
    "",
    "  ls_case-title = '3. 야간근무/석식대 2025.05'.",
    "  ls_case-pernr = '00007000'. ls_case-paydt = '20250528'.",
    "  ls_case-zstype = '100'. ls_case-year = '2025'.",
    "  APPEND ls_case TO lt_case.",
    "",
    "  ls_case-title = '4. 상여 명세서 OCRSN=0003'.",
    "  ls_case-pernr = '80000342'. ls_case-paydt = '20260930'.",
    "  ls_case-zstype = '800'. ls_case-year = '2026'.",
    "  APPEND ls_case TO lt_case.",
    "",
    "  LOOP AT lt_case INTO ls_case.",
    "    REFRESH: lr_pernr, lr_paydt, lr_orgeh.",
    "    CLEAR: lr_pernr, lr_paydt, lv_pdf, lv_fsize.",
    "    lr_pernr-sign = 'I'. lr_pernr-option = 'EQ'.",
    "    lr_pernr-low  = ls_case-pernr. APPEND lr_pernr.",
    "    lr_paydt-sign = 'I'. lr_paydt-option = 'EQ'.",
    "    lr_paydt-low  = ls_case-paydt. APPEND lr_paydt.",
    "",
    "    CALL FUNCTION 'ZHR0004_PRINT_PAYSLIP_PDF_B3T'",
    "      EXPORTING",
    "        IV_ZSTYPE   = ls_case-zstype",
    "        IV_YEAR     = ls_case-year",
    "      IMPORTING",
    "        E_PDF_DATA  = lv_pdf",
    "        E_PDF_FSIZE = lv_fsize",
    "      TABLES",
    "        IR_PERNR    = lr_pernr",
    "        IR_PAYDT    = lr_paydt",
    "        IR_ORGEH    = lr_orgeh",
    "      EXCEPTIONS",
    "        OTHERS      = 99.",
    "    WRITE: / ls_case-title.",
    "    WRITE: / '  RC:', sy-subrc, 'FSIZE:', lv_fsize,",
    "             'PDF_LEN:', xstrlen( lv_pdf ).",
    "  ENDLOOP.",
]

for i, ln in enumerate(abap):
    assert len(ln) <= 72, f"Line {i} too long ({len(ln)}): {ln}"

res = conn.call("RFC_ABAP_INSTALL_AND_RUN", PROGRAM=[{"LINE": ln} for ln in abap])
print("ERR:", res.get("ERRMESSAGE"))
for w in res.get("WRITES", []):
    print(w["ZEILE"].strip())
