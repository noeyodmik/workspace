import io, json, sys
from backends.rfc_backend import RfcBackend
from config import Settings

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

b = RfcBackend(Settings())

with open("c:/Users/sapin/Desktop/Workspace/sap-mcp/current_lzmcpu12.txt", "r", encoding="utf-8") as f:
    text = f.read()

# 1. Update inper string logic
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

# 2. Update ABKRS parameters
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

lines = [{"LINE": l} for l in text.splitlines()]

with b._conn() as c:
    r = c.call("RPY_INCLUDE_UPDATE",
               INCLUDE_NAME="LZMCPU12",
               TRANSPORT_NUMBER="EA3K900019",
               SAVE_INACTIVE=" ",
               SOURCE_EXTENDED=lines)
    print("RPY_INCLUDE_UPDATE for ABKRS completed!")
