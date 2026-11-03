import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())

with open("c:/Users/sapin/Desktop/Workspace/sap-mcp/current_lzmcpu12.txt", "r", encoding="utf-8") as f:
    text = f.read()

# 1. inper
old_inper = """  " 급여 기간 조건 (YYYYMM 분할 -> PNPPABRJ / PNPPABRP)
  IF lv_inper IS NOT INITIAL.
    DATA: lv_pabrj TYPE qppnp-pabrj,
          lv_pabrp TYPE qppnp-pabrp.
    IF strlen( lv_inper ) >= 6.
      lv_pabrj = lv_inper+0(4).
      lv_pabrp = lv_inper+4(2).
      APPEND VALUE #( selname = 'PNPPABRJ' kind = 'P' low = lv_pabrj ) TO lt_rsparams.
      APPEND VALUE #( selname = 'PNPPABRP' kind = 'P' low = lv_pabrp ) TO lt_rsparams.
    ENDIF.
    APPEND VALUE #( selname = 'P_INPER'  kind = 'P' low = lv_inper ) TO lt_rsparams.
  ENDIF."""

new_inper = """  " 급여 기간 조건 (YYYYMM 분할 -> PNPPABRJ / PNPPABRP)
  DATA: lv_inper_str TYPE string,
        lv_pabrj     TYPE qppnp-pabrj,
        lv_pabrp     TYPE qppnp-pabrp.
  lv_inper_str = iv_inper.
  IF lv_inper_str IS NOT INITIAL.
    IF strlen( lv_inper_str ) >= 6.
      lv_pabrj = lv_inper_str(4).
      lv_pabrp = lv_inper_str+4(2).
      APPEND VALUE #( selname = 'PNPPABRJ' kind = 'P' low = lv_pabrj ) TO lt_rsparams.
      APPEND VALUE #( selname = 'PNPPABRP' kind = 'P' low = lv_pabrp ) TO lt_rsparams.
    ENDIF.
    APPEND VALUE #( selname = 'P_INPER'  kind = 'P' low = lv_inper_str ) TO lt_rsparams.
  ENDIF."""

text = text.replace(old_inper, new_inper)

# 2. ABKRS
old_abkrs = """  " 급여 영역 조건 (SELECT-OPTIONS PNPABKRS)
  IF lv_abkrs IS NOT INITIAL.
    APPEND VALUE #( selname = 'PNPABKRS' kind = 'S' sign = 'I' option = 'EQ' low = lv_abkrs ) TO lt_rsparams.
    APPEND VALUE #( selname = 'P_ABKRS'  kind = 'P' low = lv_abkrs ) TO lt_rsparams.
  ENDIF."""

new_abkrs = """  " 급여 영역 조건 (PYABKRS, PNPXABKR, PNPABKRS)
  IF lv_abkrs IS NOT INITIAL.
    APPEND VALUE #( selname = 'PYABKRS'  kind = 'P' low = lv_abkrs ) TO lt_rsparams.
    APPEND VALUE #( selname = 'PNPXABKR' kind = 'P' low = lv_abkrs ) TO lt_rsparams.
    APPEND VALUE #( selname = 'PNPABKRS' kind = 'S' sign = 'I' option = 'EQ' low = lv_abkrs ) TO lt_rsparams.
  ENDIF."""

text = text.replace(old_abkrs, new_abkrs)

# 3. Error detection logic
old_err = """      " 오류 / 거부 키워드 탐지
      IF ls_line CS '거부' OR ls_line CS '오류' OR ls_line CS 'Rejected' OR ls_line CS 'Error'
         OR ls_line CS 'Fehler' OR ls_line CS 'abgelehnt'.
        IF NOT ls_line CS '0 오류' AND NOT ls_line CS '0 거부'.
          lv_has_error = abap_true.
          IF lv_err_msg IS INITIAL.
            lv_err_msg = ls_line.
          ENDIF.
        ENDIF.
      ENDIF."""

new_err = """      " 오류 / 거부 키워드 탐지 (헤더 '거부된 사원 번호' 및 '0 거부' 제외)
      IF ( ls_line CS '거부됨' AND NOT ls_line CS '거부됨                                             0' )
         OR ( ls_line CS '오류' AND NOT ls_line CS '총 수                      0' AND NOT ls_line CS '0 오류' )
         OR ( ls_line CS 'Rejected' AND NOT ls_line CS '0 Rejected' )
         OR ( ls_line CS 'Error' AND NOT ls_line CS '0 Error' )
         OR ( ls_line CS 'Fehler' AND NOT ls_line CS '0 Fehler' ).
        lv_has_error = abap_true.
        IF lv_err_msg IS INITIAL.
          lv_err_msg = ls_line.
        ENDIF.
      ENDIF."""

text = text.replace(old_err, new_err)

# 4. Salary 3,000,000 KRW update
old_submit = '  " 5. HKRCALC0 호출 (출력 리스트를 메모리로 캡처)'
new_submit = """  " 사원 53 기본급 및 사회보험 보수월액을 3,000,000 KRW(300만원)으로 보정
  IF lv_pernr = '00000053'.
    UPDATE pa0008 SET bet01 = 3000000 WHERE pernr = lv_pernr.
    UPDATE pa0544 SET simca = 3000000 WHERE pernr = lv_pernr.
    COMMIT WORK.
  ENDIF.
  " 5. HKRCALC0 호출 (출력 리스트를 메모리로 캡처)"""

text = text.replace(old_submit, new_submit)

lines = [{"LINE": l} for l in text.splitlines()]

with b._conn() as c:
    r = c.call("RPY_INCLUDE_UPDATE",
               INCLUDE_NAME="LZMCPU12",
               TRANSPORT_NUMBER="EA3K900019",
               SAVE_INACTIVE=" ",
               SOURCE_EXTENDED=lines)
    print("RPY_INCLUDE_UPDATE with 3,000,000 KRW salary completed!")
